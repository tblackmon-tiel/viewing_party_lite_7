class User < ApplicationRecord
  has_many :party_users
  has_many :parties, through: :party_users

  validates :name, presence: true
  validates :email, presence: true

  def hosted_parties
    Party.joins(:party_users)
      .where("party_users.user_id = ? AND party_users.is_host = true", self.id)
  end

  def invited_parties
    Party.joins(:party_users)
      .where("party_users.user_id = ? AND party_users.is_host = false", self.id)
  end
end