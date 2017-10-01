# frozen_string_literal: true

class AddStartTimeToTask < ActiveRecord::Migration[5.1]
  def self.up
    add_column :tasks, :start_time, :timestamp
  end

  def self.down
    remove_column :tasks, :start_time
  end
end
