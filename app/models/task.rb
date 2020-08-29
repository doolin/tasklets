# frozen_string_literal: true

class Task < ActiveRecord::Base
  belongs_to :user

  # https://guides.rubyonrails.org/association_basics.html#self-joins
  # to create a tree structure.
  has_many :children, class_name: "Task", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Task", optional: true

  validates :description, presence: true
end
