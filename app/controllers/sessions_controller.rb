class SessionsController < ApplicationController

  # GET /login
  def new
  end

  # POST /login
  def create
    @user = User.find_by_email(params[:email])
    # user exists in the database and password is correct
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_url
    else
      flash.now[:danger] = "Invalid email/password"
      render 'new'
    end
  end

  # DELETE /logout
  def destroy
    session.delete(:user_id)
    redirect_to root_url
  end

end
