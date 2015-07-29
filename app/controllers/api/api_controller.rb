class Api::ApiController < ActionController::Base

  protect_from_forgery
  before_filter :require_login
  
  private

    def require_login
      redirect_to login_url unless current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user
end
