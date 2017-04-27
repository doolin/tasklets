# frozen_string_literal: true

class AddStartTimeToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :start_time, :timestamp
  end

  def self.down
    remove_column :tasks, :start_time
  end
end
