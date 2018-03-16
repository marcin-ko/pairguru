class Api::V2::GenreResource < JSONAPI::Resource
  attributes :name, :movies_count
end
