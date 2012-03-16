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

end