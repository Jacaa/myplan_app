class StaticPagesController < ApplicationController
  
  # GET /home
  def home
    if logged_in?
      @micropost = current_user.microposts.build 
      @posts = current_user.posts
      @user = current_user
    end
  end

  # GET /about
  def about
  end
end
