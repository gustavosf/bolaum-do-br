class User < ActiveRecord::Base
  has_secure_password

  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :photo
  validates_presence_of :password, :on => :create

  validates_uniqueness_of :email

  has_many :bets
  has_many :standings
  has_many :league_teams

  default_scope { order 'id ASC' }
end