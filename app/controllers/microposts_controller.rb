class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def new
    @micropost = Micropost.new
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comments = @micropost.comments.all
    @comment = Comment.new
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "投稿が完了しました！"
      redirect_to root_url, status: :see_other
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿が削除されました"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
