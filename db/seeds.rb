# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

=begin
  User.delete_all
  User.create(:email => 'gustavo', :password => 'falkland', :name => 'Gustavo', :photo => '/photos/gustavo.jpg')
  User.create(:email => 'mauri', :password => '12345', :name => 'Mauricio', :photo => '/photos/mauricio.jpg')
=end

require 'json'
require 'net/http'

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

camp_id = 394 # brasileirão 2015
resource = 'http://www.footstats.net/partida/getCalendarioCampeonato?campeonato=' + camp_id + '&temporada=&rodada='

(1..38).each do |round|
  resp = Net::HTTP.get_response(URI.parse(resource + round)).body
  resp = Net::HTTP.get_response(URI.parse(resource + round)).body
  json = JSON.parse resp

  #loading all games
  games = json['lista_de_jogos']['campeonato']['edicao_campeonato']['fases'][0]['jogos']
  games.each do |game| # here, game is an array, not an object (no keys indeed)
    Game.new do |g|
      g.id            = game['jogo_id']
      g.round         = game['rodada']
      g.date          = Time.parse(game['data_original'] + ' ' + (game['hora'] or '00h00').gsub('h', ':') + ':00').utc
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
end