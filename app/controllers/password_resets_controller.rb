class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:create, :edit, :update]
  before_action :valid_user, only: [:edit, :update]

  # GET new_password_reset_path
  def new
  end
  
  # POST password_resets_path
  def create
    if @user
      @user.set_reset_token
      @user.send_password_reset_email
      flash[:success] = "Check your email for further steps"
      redirect_to root_url
    else
      flash.now[:danger] = "Email not found"
      render "new"
    end
  end

  # GET edit_password_reset_path(:user)
  def edit
  end

  # PATCH password_reset_path(:user)
  def update
    if @user.reset_sent_at < 2.hours.ago
      flash[:warning] = "Password reset has expired"
      redirect_to new_password_reset_path
    elsif params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render "edit"
    elsif params[:user][:password].length < 5
      @user.errors.add(:password, "is too short (5 characters minimum)")
      render "edit"
    elsif @user.update_attributes(user_params)
      flash[:success] = "Password has been reset"
      @user.update_columns(reset_token: nil, reset_sent_at: nil)
      redirect_to root_url
    else
      render "edit"
    end
  end

  private 

    def set_user
      @user = User.find_by_email(params[:email])
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset_token, params[:id]))
        message = "Something goes wrong."
        message += " Check if your account was activated."
        flash[:warning] = message
        redirect_to root_url
      end
    end
end
