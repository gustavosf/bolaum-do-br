class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.int :round
      t.datetime :date
      t.int :stadium_id
      t.int :home_id
      t.int :visitor_id
      t.int :home_score
      t.int :visitor_score
      t.double :attendance
      t.float :income
      t.string :url

      t.timestamps
    end
  end
end
