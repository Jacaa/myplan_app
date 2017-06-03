class SessionsController < ApplicationController

  # POST /login
  def create
    user = User.find_by_email(params[:email])
    # user exists in the database and password is correct
    if user && user.authenticate(params[:password])
      if user.activated
        if params[:remember_me]
          cookies.permanent[:remember_token] = user.remember_token
        else
          cookies[:remember_token] = user.remember_token
        end
        redirect_to root_url
      else
        flash[:danger] = "Account not activated. Check your email."
        redirect_to root_url 
      end
    else
      flash[:danger] = "Invalid email or password"
      redirect_to root_url
    end
  end

  # DELETE /logout
  def destroy
    cookies.delete(:remember_token)
    redirect_to root_url
  end
end
