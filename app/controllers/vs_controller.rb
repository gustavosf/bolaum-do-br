class VsController < ApplicationController
  
  def round
    #debugger
    if params[:round].nil? or not (1..38).include?(params[:round].to_i)
      @actual_round = Game.actual_round
    else
      @actual_round = params[:round].to_i
    end
    @round   = Game.find_all_by_round @actual_round
    @players = User.all
  end

  def league_team
    @players = User.all
    @round = Game.next_round
  end

  def standing
    @players = User.all
    @round = Game.next_round
  end
end
