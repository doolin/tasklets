# frozen_string_literal: true

class AddParentIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :parent, foriegn_key: true
  end
end
