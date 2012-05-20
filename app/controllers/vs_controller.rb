class VsController < ApplicationController
  
  def round
    @round   = Game.find_all_by_round Game.actual_round - 1
    @players = User.all
  end

  def league_team
    @players = User.all
    @round = 2
  end
end
