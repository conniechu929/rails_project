class CommentsController < ApplicationController
  def index
  end

  def create
    Comment.create(content:params[:content], favorite_id:params[:id])
    redirect_to :back
  end

  def show
    @favorite = Favorite.find_by_id(params[:id])
    @comments = Comment.where(favorite_id:params[:id])
  end
end
