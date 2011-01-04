class AddFinishTimeToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :finish_time, :timestamp
  end

  def self.down
    remove_column :tasks, :finish_time
  end
end
