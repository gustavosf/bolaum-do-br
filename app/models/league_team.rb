class LeagueTeam < ActiveRecord::Base

  default_scope :order => 'first ASC'

  belongs_to :user
  belongs_to :club

end
