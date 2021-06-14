class PostImagesController < ApplicationController
  before_action :set_post_image, only: [:show, :edit, :update, :destroy]
  def new
    @post_image = PostImage.new
  end

  # 投稿データの保存
  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    @post_image.save
     if @post_image.save
      redirect_to post_images_path
     else
      render :new
     end
  end

  def index
    @post_images = PostImage.all
    # @post_images = PostImage.page(params[:page]).reverse_order
    @q = PostImage.ransack(params[:q])
    @post_images = @q.result(distinct: true)
  end

  def show
    # @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    # @post_image = PostImage.find(params[:id])
  end

  def update
    # @post_image = PostImage.find(params[:id])
    @post_image.update(post_image_params)
    redirect_to post_image_path(@post_image.id)
  end

  def destroy
    # @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end
  
  

  # 投稿データのストロングパラメータ
  private
  # 別メソッドとして定義
  def set_post_image
    @post_image = PostImage.find(params[:id])
  end

  def post_image_params
    params.require(:post_image).permit(:title, :image, :caption)
  end
end
