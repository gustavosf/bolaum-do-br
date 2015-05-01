# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'json'
require 'net/http'

# Cria os usuários, se eles ainda nao existirem
u = User.find_by_email 'gustavosf@gmail.com'
if u.nil?
  User.new do |u|
    u.email    = 'gustavosf@gmail.com'
    u.password = '12345'
    u.name     = 'Gustavo'
    u.photo    = '/photos/gustavo.jpg'
    u.save
  end
end

u = User.find_by_email 'mauriciosf@gmail.com'
if u.nil?
  User.new do |u|
    u.email    = 'mauriciosf@gmail.com'
    u.password = '12345'
    u.name     = 'Mauricio'
    u.photo    = '/photos/mauricio.jpg'
    u.save
  end
end

puts "Criados usuarios do bolao"

# Busca os times e jogos

camp_id = APP_CAMP_ID # config/initializers/bolao.rb
resource = "http://www.footstats.net/partida/getCalendarioCampeonato?campeonato=#{camp_id}&temporada=&rodada="

Game.destroy_all(camp_id: camp_id)

(1..38).each do |round|
  resp = Net::HTTP.get_response(URI.parse(resource + round.to_s)).body
  resp = Net::HTTP.get_response(URI.parse(resource + round.to_s)).body
  json = JSON.parse resp

  # Busca todos os jogos da rodada "round" no
  games = json['Data']['Partidas']

  if round == 1 # Na carga da primeira rodada, cria os times no banco de dados
    games.each do |game|
      if Club.find_by_abr(game['SiglaMandante']).nil?
        Club.new do |c|
          c.abr  = game['SiglaMandante']
          c.name = game['Mandante']
          c.logo = game['LogoMandante']
          c.save
        end
      end
      if Club.find_by_abr(game['SiglaVisitante']).nil?
        Club.new do |c|
          c.abr  = game['SiglaVisitante']
          c.name = game['Visitante']
          c.logo = game['LogoVisitante']
          c.save
        end
      end
    end
    puts "Carregados times do campeonato"
  end

  # Carrega a lista de jogos
  games.each do |game|
    Game.new do |g|
      g.camp_id       = camp_id
      g.round         = round
      g.date          = DateTime.strptime(game['DataHora'], '%d/%m/%Y - %H:%M')
      g.stadium       = game['Estadio']
      g.home_id       = game['SiglaMandante']
      g.visitor_id    = game['SiglaVisitante']
      g.home_score    = game['PlacarMandante']
      g.visitor_score = game['PlacarVisitante']
      g.save
    end
  end
  puts "Carregados jogos da rodada " + round.to_s
end
