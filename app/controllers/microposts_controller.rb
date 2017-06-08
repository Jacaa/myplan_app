class MicropostsController < ApplicationController
  before_action :user_is_logged, only: [:create, :destroy]

  def edit
    @micropost = Micropost.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(micropost_params)
      flash[:success] = "Post edited"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = "Try again!"
      redirect_to request.referrer || root_url
    end
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Post created"
      redirect_to root_url
    else
      flash[:danger] = "Content has over 140 characters. Try again!"
      redirect_to controller: :static_pages, action: :home
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    if @micropost.nil?
      redirect_to root_url if @micropost.nil?
    else
      @micropost.destroy
      flash[:success] = "Post deleted"
      redirect_to request.referrer || root_url
    end
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
