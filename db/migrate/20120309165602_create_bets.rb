class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :home_score
      t.integer :visitor_score
      t.integer :points

      t.timestamps
    end
  end
end
