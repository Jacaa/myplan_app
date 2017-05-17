module SessionsHelper

  # Logs in the user, not permanent
  def login(user)
    cookies[:remember_token] = user.remember_token
  end
  
  # Return the current user
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
  end
  
  # Returns true if user is logged on
  def logged_in?
    !current_user.nil?
  end

  # Check if current user i
  def correct_user(user)
    user == current_user
  end
end
