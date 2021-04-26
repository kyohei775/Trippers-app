class UsersController < ApplicationController
  def index
    @users = User.all
    @post_image = PostImage.new
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end
  
  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images
    # .page(params[:page]).reverse_order
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end
  
  def timeline
    @user = current_user
    # @users = @user.following_user
    # follows_ids = @user.following_user.pluck(:id)  # フォローしている人のIDだけを取り出す
    # follows_ids.push(@user.id)                       # フォローしている人のID配列に自分のIDも追加
    # @post_images = PostImage.where(user_id: follows_ids).page(params[:page]).reverse_order
  end
  
   private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
