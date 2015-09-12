class Game < ActiveRecord::Base

  has_many :bets
  belongs_to :home, class_name: 'Club', primary_key: 'abr'
  belongs_to :visitor, class_name: 'Club', primary_key: 'abr'
  default_scope where(camp_id: APP_CAMP_ID)

  def self.actual_round
    r = Game.find(
      :first,
      :select => 'round',
      :conditions => ["date < ?", Time.now.utc],
      :group => 'round',
      :having => 'count(*) > 1',
      :order => 'round DESC'
    )
    if r then
      r.round
    else
      0
    end
  end

  def self.round_games (round)
    Game.find(:all, conditions: {round: round}, :order => :date)
  end

  def self.round_games_with_bets (round)
    Game.includes(:bets).find(:all, conditions: {round: round}, :order => :date)
  end

  def self.next_round() actual_round + 1 end
  def self.next_round_games() round_games next_round end
  def self.actual_round_games() round_games actual_round end
  def self.first_game_of_next_round() next_round_games.second end

  def update_bets
    bets.each do |bet|
      bet.update_points home_score, visitor_score
    end
  end

end
