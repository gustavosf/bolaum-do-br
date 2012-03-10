class Game < ActiveRecord::Base

  has_many :bets
  belongs_to :stadium
  belongs_to :home, :class_name => 'Club'
  belongs_to :visitor, :class_name => 'Club'

  def self.actual_round
    date = Game.find(
      :first,
      :conditions => ["date > ?", Time.now],
      :group => 'date',
      :having => 'count(*) > 1',
      :select => 'date',
      :order => 'date ASC').date
    Game.find(:first, :conditions => ["date = ?", date]).round
  end

  def self.actual_round_games
    Game.find_all_by_round Game.actual_round
  end

  def self.first_game_of_round
    Game.actual_round_games.first
  end

end
