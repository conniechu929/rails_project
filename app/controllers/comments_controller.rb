class CommentsController < ApplicationController
  def index
  end

  def create
    @comment = Comment.create(content:params[:content], favorite_id:params[:id])
  end

  def show
    
  end
end
