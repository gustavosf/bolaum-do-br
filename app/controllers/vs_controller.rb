class VsController < ApplicationController
  
  def rodada
    @round   = Game.actual_round_games
    @players = User.all
  end

end
