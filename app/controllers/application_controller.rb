class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private 
  
    # Before filter
    def user_is_logged
      unless logged_in?
        flash[:warning] = "Please log in."
        redirect_to login_path
      end
    end
end
