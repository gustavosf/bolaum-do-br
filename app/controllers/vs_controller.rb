class VsController < ApplicationController
  
  def round
    if params[:round].nil? or not (1..38).include?(params[:round].to_i)
      @actual_round = Game.actual_round
    else
      @actual_round = params[:round].to_i
    end
    @round   = Game.find_all_by_round @actual_round, :order => 'date'
    @players = User.all
  end

end
