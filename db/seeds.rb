# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

=begin
  User.delete_all
  User.create(:email => 'gustavo', :password => 'falkland', :name => 'Gustavo', :photo => '/photos/gustavo.jpg')
  User.create(:email => 'mauri', :password => '12345', :name => 'Mauricio', :photo => '/photos/mauricio.jpg')
=end

require 'json'
require 'net/http'

resource = 'http://globoesporte.globo.com/dynamo/futebol/campeonato/campeonato-brasileiro/brasileirao2013/classificacao.json'

resp = Net::HTTP.get_response(URI.parse(resource)).body
resp = Net::HTTP.get_response(URI.parse(resource)).body
json = JSON.parse resp

User.delete_all
User.new do |u|
  u.email = 'gustavosf@gmail.com'
  u.password = 'falkland'
  u.name = 'Gustavo'
  u.photo = '/photos/gustavo.jpg'
  u.save
end
User.new do |u|
  u.email = 'mauriciosf@gmail.com'
  u.password = '12345'
  u.name = 'Mauricio'
  u.photo = '/photos/mauricio.jpg'
  u.save
end

# loading all clubs
Club.delete_all
clubs = json['lista_de_jogos']['campeonato']['edicao_campeonato']['equipes']
clubs.each do |club|
  Club.new do |c|
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

# loading all stadiuns
Stadium.delete_all
stadiuns = json['lista_de_jogos']['campeonato']['edicao_campeonato']['sedes']
stadiuns.each do |stadium|
  Stadium.new do |s|
    s.id           = stadium[0]
    s.max_capaticy = stadium[1]['capacidade_maxima']
    s.inauguration = stadium[1]['inauguracao']
    s.location     = stadium[1]['localizacao']
    s.name         = stadium[1]['nome']
    s.popular_name = stadium[1]['nome_popular']
    s.save
  end
end

#loading all games
Game.delete_all
games = json['lista_de_jogos']['campeonato']['edicao_campeonato']['fases'][0]['jogos']
games.each do |game| # here, game is an array, not an object (no keys indeed)
  Game.new do |g|
    g.id            = game['jogo_id']
    g.round         = game['rodada']
    g.date          = game['data_original']
    g.stadium_id    = game['sede']
    g.home_id       = game['equipe_mandante']
    g.visitor_id    = game['equipe_visitante']
    g.home_score    = game['placar_mandante']
    g.visitor_score = game['placar_visitante']
    g.attendance    = game['public_total']
    g.income        = game['renda']['total']
    g.url           = game['url_confronto']
    g.save
  end
end