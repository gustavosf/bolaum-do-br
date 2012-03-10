class Stadium < ActiveRecord::Base
  set_table_name 'stadiums'

  has_many :games, :primary_key => 'stadium_id'
end
