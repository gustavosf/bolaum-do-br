class Games < ActiveRecord::Base

  has_many :bets
  has_one  :stadium
  has_one  :home, :class_name => 'Clubs'
  has_one  :visitor, :class_name => 'Clubs'

end
