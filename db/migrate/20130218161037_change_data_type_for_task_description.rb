# frozen_string_literal: true

class ChangeDataTypeForTaskDescription < ActiveRecord::Migration[5.1]
  def up
    change_table :tasks do |t|
      t.change :description, :text
    end
  end

  def down
    change_table :tasks do |t|
      t.change :description, :string
    end
  end
end
