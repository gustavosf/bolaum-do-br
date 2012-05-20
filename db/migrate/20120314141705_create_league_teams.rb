class CreateLeagueTeams < ActiveRecord::Migration
  def change
    create_table :league_teams do |t|
      t.integer :user_id
      t.integer :club_id
      t.string :player
      t.string :position
      t.boolean :first

      t.timestamps
    end
  end
end
