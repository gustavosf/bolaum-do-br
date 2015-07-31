Bolao::Application.routes.draw do

  root :to => 'apostas#index'

  # API routes
  namespace :api do
    namespace :v1 do
      controller :bet do
        get  'round(/:round)'      => :round
        get  'round(/:round)/bets' => :round_bets
        get  'round(/:round)/vs'   => :vs
        put  'round(/:round)'      => :update
        post 'bet'                 => :bet
      end
      controller :login do
        post 'token' => :login
      end
    end
  end

  controller :apostas do
    get 'regulamento' => :rules
    post 'rodada' => :rodada
    post 'bet' => :bet
    post 'update' => :update_bets
    post 'overview' => :overview
    post 'prizes' => :prizes
  end

  resources :sessions, :only => [:new, :create, :destroy]
  controller :sessions do 
    get  'login'  => :new
    post 'login'  => :create
    get  'logout' => :destroy
  end

  controller :users do
    get  'pass' => :change_pass
    post 'pass' => :save_pass
  end

  controller :vs do
    get 'vs/rodada(/:round)' => :round
  end

end
