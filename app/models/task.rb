# frozen_string_literal: true

class Task < ActiveRecord::Base
  validates :description, presence: true
end
