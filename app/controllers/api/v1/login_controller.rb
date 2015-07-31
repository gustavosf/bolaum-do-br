# encoding: utf-8

class Api::V1::LoginController < Api::ApiController

  def login
    @user = User.find(params[:user_id])
    if @user && @user.authenticate(params[:password])
      @user.api_key = User.generate_api_key
      @user.save
      render json: @user
    else
      render json: ["erro"]
    end

  end

end