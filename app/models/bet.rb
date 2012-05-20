class Bet < ActiveRecord::Base

  belongs_to :user
  belongs_to :game

  def update_points (home, visitor)
    score = 0
    score += 1 if home == home_score
    score += 1 if visitor == visitor_score
    score += 3 if home > visitor and home_score > visitor_score
    score += 3 if home == visitor and home_score == visitor_score
    score += 3 if home < visitor and home_score < visitor_score
    score += 1 if score == 5
    self.points = score
    save!
  end

end
