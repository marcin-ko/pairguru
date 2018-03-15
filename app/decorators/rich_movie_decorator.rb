class RichMovieDecorator < Draper::Decorator
  delegate_all

  def description
    context[:movie_json][:data][:attributes][:plot]
  end

  def avatar
    "#{context[:api_host]}#{context[:movie_json][:data][:attributes][:poster]}"
  end

  def rating
    context[:movie_json][:data][:attributes][:rating]
  end
end
