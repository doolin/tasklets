# frozen_string_literal: true

class Task < ActiveRecord::Base
  belongs_to :user

  # https://guides.rubyonrails.org/association_basics.html#self-joins
  # to create a tree structure.
  has_many :children, class_name: 'Task', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Task', optional: true

  validates :description, presence: true

  def self.count_descendents_with_cte(id = nil)
    descendents_with_cte(id)[0]['count']
  end

  def self.descendents_with_cte(id)
    id = id.nil? ? 'IS NULL' : "= #{id}"

    # This pulls all the descendents into a flat array.
    sql = <<-SQL
      WITH RECURSIVE tree AS (
        select t.id, t.parent_id, t.tags from tasks t where parent_id #{id}
        UNION ALL
        select t1.id, t1.parent_id, t1.tags from tree
        join tasks t1 ON t1.parent_id = tree.id
      ) SELECT count(*) FROM tree
    SQL

    # connection is in the ConnectionHandling module which is included in Base:
    # https://github.com/rails/rails/blob/master/activerecord/lib/active_record/base.rb#L271
    ActiveRecord::Base.connection.execute(sql)
  end
end
