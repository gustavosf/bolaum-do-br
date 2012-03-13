# encoding: utf-8

class ApostasController < ApplicationController

  def index
    @user = current_user
  end

  def rodada
    @games = Game.actual_round_games

    render 'rodada', :layout => false
  end

  def bet
    @ret = {}
    bet = current_user.bets.find_by_game_id(params[:game_id])
    bet = Bet.new if bet.nil?

    if Game.first_game_of_round.date < Time.now
      @ret['error'] = true
      @ret['message'] = 'A data limite para aposta neste jogo já passou'
      @ret['score'] = [bet.home_score, bet.visitor_score]
    else
      bet.game_id = params[:game_id]
      bet.user_id = current_user.id
      bet.home_score = params[:bet][0]
      bet.visitor_score = params[:bet][1]
      bet.save
      @ret['message'] = "#{bet.game.home.popular_name} #{bet.home_score}-#{bet.visitor_score} #{bet.game.visitor.popular_name} salvo"
    end
    
    respond_to do |format|
      format.json { render :json => @ret }
    end
  end

  def standing
    @standings = current_user.standings
  end

end