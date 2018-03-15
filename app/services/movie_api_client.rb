require 'open-uri'

class MovieAPIClient
  attr_reader :movie_json

  def initialize(options = {})
    @name = URI.encode(options[:movie_name])
  end

  def call
    @movie_json ||= get_movie_json
  end

  def host
    'https://pairguru-api.herokuapp.com'
  end

  private

  def get_movie_json
    JSON.parse(fetch_movie_api).with_indifferent_access
  rescue OpenURI::HTTPError => e
    Rails.logger.warn "Error when fetching movie json for title: #{@name} - #{e.message}"
  end

  def fetch_movie_api
    open(api_url).read
  end

  def api_url
    "#{host}/api/v1/movies/#{@name}"
  end
end
