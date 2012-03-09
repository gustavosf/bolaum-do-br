class Bets < ActiveRecord::Base

  belongs_to :user
  has_one    :game

end
