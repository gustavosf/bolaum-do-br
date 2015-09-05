require 'json'

namespace :bolao do

  desc "Atualiza jogos e apostas de todas as rodadas"
  task :update_all => :environment do
    (1..38).each do |round|
      update_status = Bet.update_round round
      puts update_status ? "Rodada #{round} atualizada" : "Problema ao atualizar a rodada #{round}"
    end
  end

  desc "Atualiza jogos e apostas para todas as 38 rodadas do campeonato"
  task :update => :environment do
    actual_round = Game.actual_round
    (actual_round .. 38).each do |round|
      update_status = Bet.update_round round
      puts update_status ? "Rodada #{round} atualizada" : "Problema ao atualizar a rodada #{round}"
    end
  end

  desc "Atualiza jogos e apostas para uma rodada em especifico"
  task :update_round, [:round] => :environment do |t, args|
    update_status = Bet.update_round args[:round]
    puts update_status ? "Rodada #{args[:round]} atualizada" : "Problema ao atualizar a rodada #{args[:round]}"
  end

end