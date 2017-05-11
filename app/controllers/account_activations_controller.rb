class AccountActivationsController < ApplicationController

  # GET /account_activations/:token/edit
  def edit
    user = User.find_by_email(params[:email])
    if user && !user.activated && user.authenticated?(params[:id])
      user.activate
      login(user)
      flash[:success] = "Acount activated!"
      redirect_to user
    else
       flash.now[:danger] = "Invalid link!"
       redirect_to root_url
    end
  end
end
