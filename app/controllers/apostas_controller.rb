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
      @ret['message'] = "#{bet.game.home.popular_name} #{bet.home_score}-#{bet.visitor_score} #{bet.game.visitor.popular_name} salvo"
    end

    respond_to do |format|
      format.json { render :json => @ret }
    end
  end

  def standing
    @standings = current_user.standings
    @round = Game.next_round
    if (@standings.empty?)
      Club.all.each_with_index do |club, index|
        Standing.new do |s|
          s.user_id = current_user.id
          s.club_id = club.id
          s.position = index + 1
          s.round = 0
          s.save
        end
        Standing.new do |s|
          s.user_id = current_user.id
          s.club_id = club.id
          s.position = index + 1
          s.round = 1
          s.save
        end
      end
      @standings = current_user.standings
    end

    render 'standing', :layout => false
  end

  def standing_bet
    Standing.delete_all(:round => params[:round], :user_id => current_user.id)

    params[:standings].each_with_index do |club, index|
      Standing.new do |s|
        s.user_id = current_user.id
        s.club_id = club
        s.position = index + 1
        s.round = params[:round]
        s.save
      end
    end
    render :nothing => true
  end

  def league_team
    @team = current_user.league_teams
    @round = Game.next_round
    render 'league_team', :layout => false
  end

  def league_position
    if params[:bet].nil?
      @team = current_user.league_teams.find_all_by_position params[:position]
      @clubs = Club.all
      render 'league_position', :layout => false
    else
      LeagueTeam.delete_all(:user_id => current_user.id, :position => params[:position])
      first = LeagueTeam.new do |l|
        l.user_id = current_user.id
        l.club_id = params[:bet]['titular_time']
        l.player = params[:bet]['titular']
        l.position = params[:position]
        l.first = 1
        l.save
      end
      second = LeagueTeam.new do |l|
        l.user_id = current_user.id
        l.club_id = params[:bet]['reserva_time']
        l.player = params[:bet]['reserva']
        l.position = params[:position]
        l.first = 0
        l.save
      end
      render :json => {
        :first => "#{first.player} (#{first.club.acronym})",
        :second => "#{second.player} (#{second.club.acronym})"
      }
    end
  end

  def rules
  end

  def update_bets
    resource = 'http://globoesporte.globo.com/dynamo/futebol/campeonato/campeonato-brasileiro/brasileirao2012/classificacao.json'
    json_ret = {
      :error => false,
      :message => nil,
      :data => {}
    }
    resp = Net::HTTP.get_response(URI.parse(resource))
    if resp.nil?
      json_ret[:error] = true
      json_ret[:message] = 'Um erro ocorreu, tente novamente mais tarde'
    else
      data = JSON.parse resp.body
      round = Game.actual_round
      games = data['lista_de_jogos']['campeonato']['edicao_campeonato']['fases'][0]['jogos']
      games.each do |game| # here, game is an array, not an object (no keys indeed)
        next unless game['rodada'] == round or game['rodada'] == round + 1
        g = Game.find(game['jogo_id']) or Game.new
        played  = true if game['placar_mandante'] and game['placar_visitante']
        changed = true if game['placar_mandante'] != g.home_score or game['placar_visitante'] != g.visitor_score

        g.id            = game['jogo_id']
        g.round         = game['rodada']
        g.date          = Time.parse(game['data_original'] + ' ' + (game['hora'] or '00h00').gsub('h', ':') + ':00').utc
        g.stadium_id    = game['sede']
        g.home_id       = game['equipe_mandante']
        g.visitor_id    = game['equipe_visitante']
        g.attendance    = game['public_total']
        g.income        = game['renda']['total']
        g.url           = game['url_confronto']
        g.home_score    = game['placar_mandante']
        g.visitor_score = game['placar_visitante']
        g.update_bets if played and changed
        g.save
      end
      json_ret[:message] = 'As apostas da rodada foram atualizadas!'
    end

    render :json => json_ret
  end

end