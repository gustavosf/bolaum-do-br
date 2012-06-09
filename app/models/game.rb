class Game < ActiveRecord::Base

  has_many :bets
  belongs_to :stadium
  belongs_to :home, :class_name => 'Club'
  belongs_to :visitor, :class_name => 'Club'

  default_scope :order => 'date ASC'

  def self.actual_round
    Game.find(
      :first,
      :conditions => {:date => Time.now..2.weeks.from_now},
      :group => 'round,date',
      :having => 'count(*) > 1',
      :select => 'round',
      :order => 'round ASC').round
  end

  def self.next_round
    actual_round + 1
  end

  def self.next_round_games
    Game.find_all_by_round Game.next_round
  end

  def self.first_game_of_next_round
    Game.next_round_games.first
  end

  def update_bets
    bets.each do |bet|
      bet.update_points home_score, visitor_score
    end
  end

end
