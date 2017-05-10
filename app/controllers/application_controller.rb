class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

private 

    # Return the current user
    def current_user
      @current_user ||= User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
    end

    # Returns true if user is logged on
    def logged_in?
      !current_user.nil?
    end
    
    helper_method :current_user
end
