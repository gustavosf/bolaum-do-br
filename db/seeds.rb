# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

User.delete_all
User.create(:email => 'gustavo', :password => 'falkland', :name => 'Gustavo', :photo => '/photos/gustavo.jpg')
User.create(:email => 'mauri', :password => '12345', :name => 'Mauricio', :photo => '/photos/mauricio.jpg')

require 'json'
require 'net/http'

resource = 'http://globoesporte.globo.com/dynamo/futebol/campeonato/campeonato-brasileiro/brasileirao2012/classificacao.json'
resp = Net::HTTP.get_response(URI.parse(resource))
json = JSON.parse resp.body

# loading all clubs
Club.delete_all
clubs = json['lista_de_jogos']['campeonato']['edicao_campeonato']['equipes']
clubs.each do |club|
  Club.create(
    :id           => club[1]['equipe_id'],
    :nick         => club[1]['apelido'],
    :logo         => club[1]['escudo'],
    :name         => club[1]['nome'],
    :popular_name => club[1]['nome_popular'],
    :acronym      => club[1]['sigla'],
    :slug         => club[1]['slug']
  )
end

# loading all stadiuns
Stadium.delete_all
stadiuns = json['lista_de_jogos']['campeonato']['edicao_campeonato']['sedes']
stadiuns.each do |stadium|
  Stadium.create(
    :id           => stadium[0],
    :max_capaticy => stadium[1]['capacidade_maxima'],
    :inauguration => stadium[1]['inauguracao'],
    :location     => stadium[1]['localizacao'],
    :name         => stadium[1]['nome'],
    :popular_name => stadium[1]['nome_popular']
  )
end

#loading all games
Game.delete_all
games = json['lista_de_jogos']['campeonato']['edicao_campeonato']['fases'][0]['jogos']
games.each do |game| # here, game is an array, not an object (no keys indeed)
  Game.create(
    :id            => game['jogo_id'],
    :round         => game['rodada'],
    :date          => game['data-original'],
    :stadium_id    => game['sede'],
    :home_id       => game['equipe_mandante'],
    :visitor_id    => game['equipe_visitante'],
    :home_score    => game['placar_mandante'],
    :visitor_score => game['placar_visitante'],
    :attendance    => game['public_total'],
    :income        => game['renda']['total'],
    :url           => game['url_confronto']
  )
end