class UsersController < ApplicationController
  before_action :user_is_logged, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :update, :edit, :following, :followers]
  
  # GET /users | users_path
  def index
    @users = User.where(activated: true)
    @user = current_user
  end

  # GET /users/:id | user_path(:id)
  def show
    @posts = @user.microposts
  end
  
  # GET /users/new | new_user_path
  # Create nil user to provide @user variable for form_for
  def new
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
      respond_to do |format|
        format.js
      end
    end
  end

  # GET /users/:id/edit | edit_user_path(:id)
  def edit
  end

  # PATCH /users/:id | user_path(:id)
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile edited"
      redirect_to @user
    else
      render 'show'
    end
  end

  # DELETE /users/:id | user_path(:id)
  def destroy
    path = if admin?(current_user) 
             users_url
           else 
             root_url
           end
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to path
  end

  # GET /users/id/following | following_user_path(id)
  def following
    @title = "Following"
    @users = @user.following
    render "friends"
  end

  # GET /users/id/followers | followers_user_path(id)
  def followers
    @title = "Followers"
    @users = @user.followers
    render "friends"
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
