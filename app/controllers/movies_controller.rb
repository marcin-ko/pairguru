class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all.decorate
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def send_info
    @movie = Movie.find(params[:id])
    AsyncMovieInfoSenderWorker.perform_async(current_user.id, @movie.id)
    redirect_to movie_path(@movie), notice: "Email sent with movie info"
  end

  def export
    file_path = "tmp/movies.csv"
    AsyncMovieExporterWorker.perform_async(current_user.id, file_path)
    redirect_to root_path, notice: "Movies exported"
  end
end
