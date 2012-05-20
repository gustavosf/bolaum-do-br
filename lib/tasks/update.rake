require 'json'
require 'net/http'

namespace :update do

  def data
    resource = 'http://globoesporte.globo.com/dynamo/futebol/campeonato/campeonato-brasileiro/brasileirao2012/classificacao.json'
    resp = Net::HTTP.get_response(URI.parse(resource))
    JSON.parse resp.body
  end
  
  desc "Update club information into database"
  task :clubs do
    clubs = data['lista_de_jogos']['campeonato']['edicao_campeonato']['equipes']
    clubs.each do |club|
      c = Club.find(club[1]['organizacao_id']) or Club.new
      c.id           = club[1]['organizacao_id']
      c.nick         = club[1]['apelido']
      c.logo         = club[1]['escudo']
      c.name         = club[1]['nome']
      c.popular_name = club[1]['nome_popular']
      c.acronym      = club[1]['sigla']
      c.slug         = club[1]['slug']
      c.save
    end
  end

  desc "Update stadium information into database"
  task :stadiums do
    stadiuns = data['lista_de_jogos']['campeonato']['edicao_campeonato']['sedes']
    stadiuns.each do |stadium|
      s = Stadium.find(stadium[0]) or Stadium.new
      s.id           = stadium[0]
      s.max_capaticy = stadium[1]['capacidade_maxima']
      s.inauguration = stadium[1]['inauguracao']
      s.location     = stadium[1]['localizacao']
      s.name         = stadium[1]['nome']
      s.popular_name = stadium[1]['nome_popular']
      s.save
    end
  end

  desc "Update game information into database"
  task :games => :environment do
    games = data['lista_de_jogos']['campeonato']['edicao_campeonato']['fases'][0]['jogos']
    games.each do |game| # here, game is an array, not an object (no keys indeed)
      #next if round and (round..round+1).include?(game['rodada'])
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
    end
  end

  desc "Update round (and next round) information into database"
  task :round => :environment do
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
    end
  end
end