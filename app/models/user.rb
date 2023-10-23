# frozen_string_literal: true

class User < ApplicationRecord
  has_many :party_users
  has_many :parties, through: :party_users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password
  has_secure_password

  def hosted_parties
    Party.joins(:party_users)
         .where('party_users.user_id = ? AND party_users.is_host = true', id)
  end

  def invited_parties
    Party.joins(:party_users)
         .where('party_users.user_id = ? AND party_users.is_host = false', id)
  end

  def self.all_excluding_id(id)
    User.where.not('id = ?', id)
  end
end
