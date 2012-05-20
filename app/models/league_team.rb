class LeagueTeam < ActiveRecord::Base

  default_scope :order => 'id ASC'

  belongs_to :user
  belongs_to :club

end
