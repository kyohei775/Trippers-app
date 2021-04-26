class PostImagesController < ApplicationController
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
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post_image = PostImage.find(params[:id])
  end

  def update
    @post_image = PostImage.find(params[:id])
    @post_image.update(post_image_params)
    redirect_to post_image_path(@post_image.id)
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end
  
  def set_search
    if log_in?
      @search_word = params[:q][:title_cont] if params[:q]
      @q = current_user.feed.page(params[:page]).per(10).ransack(params[:q])
      @feed_items = current_user.feed.page(params[:page]).per(10)
      @posts = @q.result(distinct: true)
    end
  end

  # 投稿データのストロングパラメータ
  private

  def post_image_params
    params.require(:post_image).permit(:title, :image, :caption)
  end
end
