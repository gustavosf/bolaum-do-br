class Bet < ActiveRecord::Base

  belongs_to :user
  belongs_to :game

  def update_points (home, visitor)
    score = 0
    score += 1 if home == home_score
    score += 1 if visitor == visitor_score
    score += 3 if home > visitor and home_score > visitor_score
    score += 3 if home == visitor and home_score == visitor_score
    score += 3 if home < visitor and home_score < visitor_score
    score += 1 if score == 5
    self.points = score
    save!
  end

  def self.update_round (round)
    resource = "http://www.footstats.net/partida/getCalendarioCampeonato?campeonato=#{APP_CAMP_ID}&temporada=&rodada=#{round}"
    resp = Net::HTTP.get_response(URI.parse(resource))
    if resp.nil?
      false
    else
      data = JSON.parse resp.body
      games = data['Data']['Partidas']
      games.each do |game| # here, game is an array, not an object (no keys indeed)
        g = Game.where(round: round, home_id: game['SiglaMandante']).first or Game.new
        played  = true if game['PlacarMandante'].present? and game['PlacarVisitante'].present?
        changed = true if played and (game['PlacarMandante'] != g.home_score or game['PlacarVisitante'] != g.visitor_score)
        g.round         = round
        g.date          = DateTime.strptime(game['DataHora']+" BRT", '%d/%m/%Y - %H:%M %Z')
        g.stadium       = game['Estadio']
        g.home_id       = game['SiglaMandante']
        g.visitor_id    = game['SiglaVisitante']
        g.home_score    = game['PlacarMandante']
        g.visitor_score = game['PlacarVisitante']
        g.update_bets if played and changed
        g.save
      end
    end

    true

  end

end
