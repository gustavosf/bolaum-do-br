class Bolao < ActiveRecord::Base

  has_many :bets
  has_many :games

end
