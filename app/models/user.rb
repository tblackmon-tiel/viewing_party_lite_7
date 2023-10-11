class User < ApplicationRecord
  has_many :party_users
  has_many :parties, through: :party_users

  validates :name, presence: true
  validates :email, presence: true
end