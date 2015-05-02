class VsController < ApplicationController
  
  def round
    if params[:round].nil? or not (1..38).include?(params[:round].to_i)
      @actual_round = Game.actual_round
    else
      @actual_round = params[:round].to_i
    end
    @round   = Game.where(:round => @actual_round).order('date asc')
    @players = User.all
  end

end
