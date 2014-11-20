class CommentsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, except: [:new, :create, :index]
  
  def new
    @comment = Comment.new
    @type = Comment::TYPE_HASH_BY_TYPE[params[:type]]
  end

  def create
  	@comment = current_user.comments.build(params[:comment])
    @type = Comment::TYPE_HASH_BY_ID[@comment.type_id]
    if @comment.save
      flash[:success] = "Your new #{ @type[:type].downcase } has been created!"
      redirect_to comments_path(:type => "#{ @type[:type] }")
    else
      render 'new'
    end
  end

  def show
    @comment = current_user.comments.find(params[:id])
    @type = Comment::TYPE_HASH_BY_ID[@comment.type_id]
  end

  def update
  	@comment = current_user.comments.find(params[:id]) 
    @comment.assign_attributes(params[:comment])
    if @comment.valid?
      type = Comment::TYPE_HASH_BY_ID[@comment.type_id][:type] 
      @comment.save
      flash[:success] = "The #{type} has been updated!"
      redirect_to comments_path(:type => "#{ type }")
    else
      @type = Comment::TYPE_HASH_BY_ID[@comment.type_id]
      render 'show'
    end
  end

  def index
    @type = Comment::TYPE_HASH_BY_TYPE[params[:type]]
  	@comments = current_user.comments.of_type_id(@type[:id])  
    respond_to do |format|
      format.html
      format.csv { send_data Comment.to_csv(@comments, @type[:type]) }
    end
  end

  private

    def correct_user
      @comment = current_user.comments.find(params[:id])
      if @comment.nil?
        flash[:error] = "Sorry that does not belong to you!"
        redirect_to user_path(current_user)
      end
    end
end
