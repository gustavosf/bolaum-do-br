class ApostasController < ApplicationController

  def index
    @user = current_user
  end

  def rodada
    @user = current_user
    render 'rodada', :layout => false
  end

end
