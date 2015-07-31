# encoding: utf-8

class Api::V1::BetController < Api::ApiController

  before_filter :authenticate

  def round
    @ret = {}
    @ret[:round] = params[:round].nil? ? Game.actual_round : params[:round]
    @ret[:games] = Game.round_games @ret[:round]
    render json: @ret
  end

  def round_bets
    round = Game.round_games params[:round]
    @bets = []

    for game in round
      @bets.push game.bets.find_by_user_id current_user.id
    end
    render json: @bets
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
      bet.home_score = params[:home_score]
      bet.visitor_score = params[:visitor_score]
      bet.save
      @ret['message'] = "#{bet.game.home.name} #{bet.home_score}-#{bet.visitor_score} #{bet.game.visitor.name} salvo"
    end

    @ret[:bet] = bet
    render json: @ret
  end

  def update
    @ret = {
      :error => false,
      :message => nil
    }

    round = params[:round].nil? ? Game.actual_round : params[:round]
    update_success = Bet.update_round round
    if update_success
      @ret[:message] = "As apostas da rodada #{round} foram atualizadas!"
    else
      @ret[:error] = true
      @ret[:message] = 'Um erro ocorreu, tente novamente mais tarde'
    end

    render json: @ret
  end

  def vs
    @games = Game.round_games_with_bets(params[:round])
    render json: @games.to_json(:include => :bets)

  end

  #   if params[:round].nil?
  #     @actual_round = Game.actual_round
  #   else
  #     @actual_round = params[:round].to_i
  #   end
  #   @round   = Game.find_all_by_round @actual_round, :order => 'date'
  #   @players = User.all
  # end

end