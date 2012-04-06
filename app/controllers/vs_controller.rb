class VsController < ApplicationController
  
  def round
    @round   = Game.actual_round_games
    @players = User.all
  end

  def league_team
    @players = User.all
    @round = 2
  end
end
