# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :firstname
      t.string :lastname
      t.text :bio
      t.string :website
      t.string :twitter
      t.string :facebook
      t.string :linkedin
      t.string :google
      t.string :url

      t.timestamps
    end
  end
end
