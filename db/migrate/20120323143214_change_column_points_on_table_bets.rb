class ChangeColumnPointsOnTableBets < ActiveRecord::Migration
  def up
    change_column :bets, :points, :integer, :default => 0
  end

  def down
    change_column :bets, :points, :integer, :default => :null
  end
end
