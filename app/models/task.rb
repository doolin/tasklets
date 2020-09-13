# frozen_string_literal: true

class Task < ActiveRecord::Base
  belongs_to :user

  # https://guides.rubyonrails.org/association_basics.html#self-joins
  # to create a tree structure.
  has_many :children, class_name: 'Task', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Task', optional: true

  validates :description, presence: true

  # This is a nasty way to do it, makes a database call for each record.
  # But it does work!
  def descendants(root = self)
    children = []
    root.children.each do |c|
      children << descendants(c)
    end
    { tags: root.tags, children: children }
  end

  def self.to_hash(task)
    tasks = descendants_cte(task.parent_id)
    index = tasks.index { |a| a['parent_id'].nil? }
    root = tasks.delete_at(index)
    find_children(root, tasks)
    root
  end

  def self.find_children(root, array)
    # See if Array.partition provides a performance benefit. It may not, as it
    # will be creating new arrays, which is expensive. It might end up being
    # cheaper to just scan the original array.
    #
    # Also see if there is a way to get delete or friends to work to reduce the
    # original array as the recursion proceeds.
    #
    # Note: if the hash is keyed with symbols, it will overflow the stack.
    # TODO: consider stringifying or symbolizing all keys before this
    # method is called.
    root['children'] = array.filter { |a| a['parent_id'] == root['id'] }
    root['children'].each { |c| find_children(c, array) }
  end

  def self.count_descendants_with_cte(id = nil)
    sql = CteQueryBuilder.descendants_count(id)
    execute(sql)[0]['count']
  end

  def self.descendants_cte(id)
    sql = CteQueryBuilder.descendants_cte(id)
    result = execute(sql)
    # TODO: document the `as_json` method here and why it's useful
    result.as_json
  end

  def self.execute(sql)
    # connection is in the ConnectionHandling module which is included in Base:
    # https://github.com/rails/rails/blob/master/activerecord/lib/active_record/base.rb#L271
    ActiveRecord::Base.connection.execute(sql)
  end

  class CteQueryBuilder
    def self.descendants(id)
      id = id.nil? ? 'IS NULL' : "= #{id}"

      # This pulls all the descendants into a flat array.
      <<-SQL
        WITH RECURSIVE tree AS (
          select t.id, t.parent_id, t.tags from tasks t where parent_id #{id}
          UNION ALL
          select t1.id, t1.parent_id, t1.tags from tree
          join tasks t1 ON t1.parent_id = tree.id
        ) --
      SQL
    end

    def self.descendants_cte(id)
      "#{descendants(id)} select id, parent_id, tags from tree"
    end

    def self.descendants_count(id)
      "#{descendants(id)} SELECT count(*) FROM tree"
    end
  end
end
