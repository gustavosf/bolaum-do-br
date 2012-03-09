class Clubs < ActiveRecord::Base

  has_many :games, :primary_key => 'home_id'
  has_many :games, :primary_key => 'visitor_id'

end
