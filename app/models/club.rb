class Club < ActiveRecord::Base

  has_many :games, :primary_key => 'home_id'
  has_many :games, :primary_key => 'visitor_id'
  has_many :standings
  has_many :league_teams

end
