class Stadiuns < ActiveRecord::Base

  has_many :games, :primary_key => 'stadium_id'

end
