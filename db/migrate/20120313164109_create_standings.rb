class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.integer :user_id
      t.integer :position
      t.integer :club_id
      t.integer :round

      t.timestamps
    end
  end
end
