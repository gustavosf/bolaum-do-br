class ApostasController < ApplicationController

  def index
    @user = current_user
  end

  def rodada
    @games = Game.find_all_by_round Game.actual_round

    render 'rodada', :layout => false
  end

  def bet
    render :nothing => true
  end

end