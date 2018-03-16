class Api::V2::MoviesController < Api::BaseController
  def index
    @movies = Movie.includes(:genre).order(:title)
    jsonapi_render json: @movies
  end

  def show
    @movie = Movie.find(params[:id])
    jsonapi_render json: @movie
  end
end
