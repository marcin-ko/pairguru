class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_movie, only: [:create]
  before_action :load_comment, only: [:destroy]

  def create
    @comment = @movie.comments.create(comment_params.merge(commenter: current_user))
    if @comment.errors.any?
      redirect_to movie_path(@movie), alert: @comment.errors.messages.values.join(", ")
    else
      redirect_to movie_path(@movie), notice: "Comment added successfully"
    end
  end

  def destroy
    if @comment.commenter == current_user
      @comment.discard
      redirect_to movie_path(@comment.commentable), notice: "Comment deleted successfully"
    else
      redirect_to movie_path(@comment.commentable), alert: "Unauthorized"
    end
  end

  private

  def load_movie
    @movie = Movie.find(params[:movie_id])
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
