# frozen_string_literal: true

class Task < ApplicationRecord
  class TaskError < StandardError; end

  belongs_to :user

  # https://guides.rubyonrails.org/association_basics.html#self-joins
  # to create a tree structure.
  # Note: there is a migration which adds a postgres foreign key constrain to the Tasks
  # table. It is not clear how that interacts with the dependent: :destroy parameter.
  #
  # TODO: follow up on how Rails dependent: :destroy interacts with a postgres defined
  # foreign key constraint. This will require watching the postgres logs as the Rails
  # destroy event is invoked.
  has_many :children, class_name: 'Task', foreign_key: 'parent_id', dependent: :destroy, inverse_of: :parent
  belongs_to :parent, class_name: 'Task', optional: true

  validates_with TaskLabelValidator, attributes: [:label]
  validates :description, presence: true
  validates :parent_id, with: :parent_exists_or_nil

  def parent_exists_or_nil
    return true if parent_id.nil?
    return true if Task.exists?(parent_id)

    errors.add(:parent_id, :parent_id_exists)
  end

  # This is a nasty way to do it, makes a database call for each record.
  # But it does work!
  def descendants(root = self)
    children = []
    root.children.each do |c|
      children << descendants(c)
    end
    { label: root.label, children: children }
  end

  # Swap all the nodex in one subtree swap parents with all the nodes in another
  # subtree. This would be like having two teams where the team leads swap.
  #
  # Note: this method is NOT thread safe.
  def self.swap_children(task1, task2)
    raise TaskError, 'nil task' if task1.nil? || task2.nil?

    # We need to build the actual tasks instead of acquiring
    # a collection proxy (task1.children, etc) as a collection
    # is lazy loaded, and there is no "temp" variable for managing
    # the swap state. The locally built tasks provide the temporary
    # state: update both then write to database. Otherwise, one
    # task ends up with all the children.
    children1 = Task.where(parent_id: task1.id)
    children2 = Task.where(parent_id: task2.id)

    children1.each { |c| c.parent_id = task2.id }
    children2.each { |c| c.parent_id = task1.id }

    children1.each(&:save!)
    children2.each(&:save!)
  end

  def self.to_hash(task)
    tasks = descendants_cte(task.label)
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

  def self.size_with_cte(label)
    sql = CteQueryBuilder.descendants_count(label)
    execute(sql)[0]['count']
  end

  def self.count_descendants_with_cte(label)
    size = size_with_cte(label)
    size.zero? ? 0 : size - 1
  end

  def self.descendants_delete(label)
    sql = CteQueryBuilder.descendants_delete(label)
    execute(sql)
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
end
