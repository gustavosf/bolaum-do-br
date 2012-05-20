# encoding: utf-8

class ApostasController < ApplicationController

  def index
    @user = current_user
  end

  def rodada
    @games = Game.next_round_games

    render 'rodada', :layout => false
  end

  def bet
    @ret = {}
    bet = current_user.bets.find_by_game_id(params[:game_id])
    bet = Bet.new if bet.nil?

    if Game.first_game_of_next_round.date < Time.now
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
    resp = Net::HTTP.get_response(URI.parse(resource))

    json_ret = {
      :error => false,
      :message => nil,
      :data => {}
    }

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
        changed = true if game['placar_mandante'] != g.home_score and game['placar_visitante'] != g.visitor_score

        g.id            = game['jogo_id']
        g.round         = game['rodada']
        g.date          = game['data_original'] + ' ' + (game['hora'] or '00h00').gsub('h', ':') + ':00'
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
        json_ret[:message] = 'As apostas da rodada foram atualizadas!'
      end
    end

    render :json => json_ret
  end

end