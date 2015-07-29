# encoding: utf-8

class Api::V1::BetController < Api::ApiController

  def round
    render json: Game.round_games(params[:round] || Game.actual_round)
  end

  def bet
    @ret = {}
    bet = current_user.bets.find_by_game_id(params[:game_id])
    bet = Bet.new if bet.nil?

    if Game.first_game_of_next_round.date < Time.now
    # if false
      @ret['error'] = true
      @ret['message'] = 'A data limite para aposta neste jogo já passou'
      @ret['score'] = [bet.home_score, bet.visitor_score]
    else
      bet.game_id = params[:game_id]
      bet.user_id = current_user.id
      bet.home_score = params[:bet][0]
      bet.visitor_score = params[:bet][1]
      bet.save
      @ret['message'] = "#{bet.game.home.name} #{bet.home_score}-#{bet.visitor_score} #{bet.game.visitor.name} salvo"
    end

    render json: @ret
  end

  def update
    @json_ret = {
      :error => false,
      :message => nil,
      :data => {}
    }

    update_success = Bet.update_round Game.actual_round
    if update_success
      @json_ret[:message] = 'As apostas da rodada foram atualizadas!'
    else
      @json_ret[:error] = true
      @json_ret[:message] = 'Um erro ocorreu, tente novamente mais tarde'
    end

    render json: @json_ret
  end

end