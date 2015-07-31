class Api::ApiController < ActionController::Base

  private

  def authenticate
    api_key = request.headers['X-Api-Token']
    @user = User.where(api_key: api_key).first if api_key
    
    unless @user
      head status: :unauthorized
      return false
    end
  end

  def current_user 
    @user
  end

  helper_method :current_user

end
