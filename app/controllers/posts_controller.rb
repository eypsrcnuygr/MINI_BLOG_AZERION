class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[create update destroy edit]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.order('updated_at DESC')
  end

  # GET /posts/1 or /posts/1.json
  def show
    @user = @post.user
    @comments = @post.comments.order('created_at DESC')
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if check_current_user(@post.user)
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed to do this!' }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if check_current_user(@post.user)
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:header, :color, :title, :design, :body).with_defaults(user_id: current_user.id,
                                                                                        date: Time.now.in_time_zone('Istanbul').to_date)
  end
end
