# encoding: utf-8

class UsersController < ApplicationController

  def change_pass
  end

  def save_pass
    if current_user.authenticate(params[:current_password])
      current_user.password = params[:new_password]
      current_user.password_confirmation = params[:new_password_confirm]
      if current_user.save
        flash[:notice] = "Senha alterada com sucesso"
      else
        flash[:error] = "Senhas novas não batem"
      end
    else
      flash[:error] = "Senha incorreta"
    end
    render 'change_pass'
  end

end