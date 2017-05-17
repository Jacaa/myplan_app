class UsersController < ApplicationController
  before_action :user_is_logged, only: [:index, :show, :edit, :update, :destroy]

  
  # GET /users | users_path
  def index
  end

  # GET /users/:id | user_path(:id)
  def show
    set_user
  end
  
  # GET /users/new | new_user_path
  # Create nil user to provide @user variable for form_for
  def new
    @user = User.new
  end
  
  # POST /users | users_path
  def create
    @user = User.new(user_params)
    if @user.save
      message = "Welcome #{@user.name}! You successfully signed in!"
      message += " Please check your email to activate your account."
      flash[:success] = message
      @user.send_activation_email
      redirect_to root_url
    else
      render 'new'
    end
  end

  # GET /users/:id/edit | edit_user_path(:id)
  def edit
    set_user
  end

  # PATCH /users/:id | user_path(:id)
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile edited"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/:id | user_path(:id)
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :avatar,
                                   :password, :password_confirmation)
    end
end
