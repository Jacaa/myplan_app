class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

private 

    # Return the current user
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    # Returns true if user is logged on
    def logged_in?
      !current_user.nil?
    end
    
    helper_method :current_user
end
