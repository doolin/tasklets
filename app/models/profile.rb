# frozen_string_literal: true

class Profile < ActiveRecord::Base
  validates :firstname, presence: true, length: { minimum: 3 }

  belongs_to :user
end
