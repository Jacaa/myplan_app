class StaticPagesController < ApplicationController
  
  # GET /home
  def home
    if logged_in?
      @micropost = current_user.microposts.build 
      @posts = current_user.microposts.all
    end
  end

  # GET /about
  def about
  end
end
