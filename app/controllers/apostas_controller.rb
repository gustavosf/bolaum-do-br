# encoding: utf-8

class ApostasController < ApplicationController

  def index
    @user = current_user
  end

  def overview
    @rounds = Bet.find(
      :all, :joins => :game,
      :select => 'games.round, sum(CASE WHEN user_id=1 THEN points ELSE 0 END) as points_1, sum(CASE WHEN user_id=1 AND points=6 THEN 1 ELSE 0 END) as gms_1, sum(CASE WHEN user_id=2 THEN points ELSE 0 END) as points_2, sum(CASE WHEN user_id=2 AND points=6 THEN 1 ELSE 0 END) as gms_2',
      :group => 'games.round', :order => 'games.round ASC')

    @graph_rounds = @rounds.map { |round| [Integer(round.round), Integer(round.points_1), Integer(round.points_2)] }
    @graph_gms = @rounds.map { |round| [Integer(round.round), Integer(round.gms_1), Integer(round.gms_2)] }
    render 'overview', :layout => false
  end

  def prizes
    @rounds = Bet.find(
      :all, :joins => :game,
      :select => 'games.round, sum(CASE WHEN user_id=1 THEN points ELSE 0 END) as points_1, sum(CASE WHEN user_id=1 AND points=6 THEN 1 ELSE 0 END) as gms_1, sum(CASE WHEN user_id=2 THEN points ELSE 0 END) as points_2, sum(CASE WHEN user_id=2 AND points=6 THEN 1 ELSE 0 END) as gms_2',
      :group => 'games.round', :order => 'games.round ASC')

    @prize = Hash.new

    win = [0, 0]
    gms = [0, 0]
    @rounds.each do |round|
      if round.points_1 == round.points_2
        win = [0, 0]
      elsif round.points_1 > round.points_2
        win = [win[0] + 1, 0]
      else
        win = [0, win[1] + 1]
      end

      gms[0] = gms[0] + Integer(round.gms_1)
      gms[1] = gms[1] + Integer(round.gms_2)

      @prize[round.round] = Array.new unless @prize[round.round]
      if Integer(round.round) % 3 == 2
        @prize[round.round].push "Gustavo ganha prêmio pequeno (gm+#{gms[0]-gms[1]})" if gms[0] > gms[1]
        @prize[round.round].push "Mauricio ganha prêmio pequeno (gm+#{gms[1]-gms[0]})" if gms[1] > gms[0]
        gms = [0,0]
      end

      @prize[round.round].push 'Gustavo ganha prêmio pequeno (3v)' if win[0] == 3
      @prize[round.round].push 'Gustavo ganha prêmio médio (5v)' if win[0] == 5
      @prize[round.round].push 'Gustavo ganha prêmio grande (7v)' if win[0] == 7
      @prize[round.round].push 'Mauricio ganha prêmio pequeno (3v)' if win[1] == 3
      @prize[round.round].push 'Mauricio ganha prêmio médio (5v)' if win[1] == 5
      @prize[round.round].push 'Mauricio ganha prêmio grande (7v)' if win[1] == 7
    end
    render 'prizes', :layout => false

  end

  def rodada
    @games = Game.next_round_games
    # @games = Game.actual_round_games

    render 'rodada', :layout => false
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

    respond_to do |format|
      format.json { render :json => @ret }
    end
  end

  def rules
  end

  def update_bets
    json_ret = {
      :error => false,
      :message => nil,
      :data => {}
    }

    update_success = Bet.update_round Game.actual_round
    if update_success
      json_ret[:message] = 'As apostas da rodada foram atualizadas!'
    else
      json_ret[:error] = true
      json_ret[:message] = 'Um erro ocorreu, tente novamente mais tarde'
    end

    render :json => json_ret
  end

end