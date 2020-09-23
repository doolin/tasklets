# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :tasks, dependent: :destroy
  has_one :profile, dependent: :destroy

  validates :email, format: { with: Devise.email_regexp }
end
