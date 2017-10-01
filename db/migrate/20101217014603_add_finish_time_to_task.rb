# frozen_string_literal: true

class AddFinishTimeToTask < ActiveRecord::Migration[5.1]
  def self.up
    add_column :tasks, :finish_time, :timestamp
  end

  def self.down
    remove_column :tasks, :finish_time
  end
end
