class Game < ActiveRecord::Base

  has_many :bets
  belongs_to :stadium
  belongs_to :home, :class_name => 'Club'
  belongs_to :visitor, :class_name => 'Club'

  def self.actual_round
    Game.find(
      :first,
      :select => 'round',
      :conditions => ["date < ?", Time.now],
      :group => 'round',
      :having => 'count(*) > 1',
      :order => 'round DESC'
    ).round - 1
  end

  def self.next_round
    actual_round + 1
  end

  def self.next_round_games
    Game.find(:all, :conditions => {:round => next_round}, :order => :date)
  end

  def self.first_game_of_next_round
    next_round_games.first
  end

  def update_bets
    bets.each do |bet|
      bet.update_points home_score, visitor_score
    end
  end

end
