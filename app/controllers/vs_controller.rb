class VsController < ApplicationController
  
  def round
    @round   = Game.find_all_by_round Game.actual_round
    @players = User.all
  end

  def league_team
    @players = User.all
    @round = Game.actual_round
  end

  def standing
    @players = User.all
    @round = Game.actual_round
  end
end
