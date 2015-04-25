# encoding: utf-8

class SessionsController < ApplicationController

  skip_before_filter :require_login

  def new
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
  end

  def create
    user = User.find(params[:user_id])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.last_access = Time.now
      user.save
      
      respond_to do |format|
        format.html { redirect_to root_url }
        format.json { redirect_to :controller => 'apostas', :action => 'rodada', :format => 'json' }
      end
    else
      flash.now[:error] = "Senha inválida!"
      @users = User.all
      respond_to do |format|
        format.html { render "new" }
        format.json { render :json => {"erro" => "Senha inválida"} }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :notice => "Você foi deslogado"
  end

end