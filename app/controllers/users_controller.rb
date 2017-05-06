class UsersController < ApplicationController

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
      flash[:success] = "Welcome #{@user.name}! You successfully signed in!"
      #send welcome and activation email
      redirect_to @user
    else
      render 'new'
    end
  end

  # GET /users/:id/edit | edit_user_path(:id)
  def edit
  end

  # PATCH /users/:id | user_path(:id)
  def update
  end

  # DELETE /users/:id | user_path(:id)
  def destroy
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, 
                                   :password, :password_confirmation)
    end
end
