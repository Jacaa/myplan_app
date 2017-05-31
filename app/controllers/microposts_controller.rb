class MicropostsController < ApplicationController
  before_action :user_is_logged, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Post created"
      redirect_to root_url
    else
      render 'static_pages/home'
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
