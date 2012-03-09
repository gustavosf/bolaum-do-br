class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.int :game_id
      t.id :user_id
      t.int :home_score
      t.int :visitor_score
      t.int :points

      t.timestamps
    end
  end
end
