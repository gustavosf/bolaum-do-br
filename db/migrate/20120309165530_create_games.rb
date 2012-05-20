class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :round
      t.datetime :date
      t.integer :stadium_id
      t.integer :home_id
      t.integer :visitor_id
      t.integer :home_score
      t.integer :visitor_score
      t.float :attendance
      t.float :income
      t.string :url

      t.timestamps
    end
  end
end
