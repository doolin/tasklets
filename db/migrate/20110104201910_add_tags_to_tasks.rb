# frozen_string_literal: true

class AddTagsToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :tags, :string
  end

  def self.down
    remove_column :tasks, :tags
  end
end
