# frozen_string_literal: true

class Task < ActiveRecord::Base
  validates :description, presence: true

  belongs_to :user
end
