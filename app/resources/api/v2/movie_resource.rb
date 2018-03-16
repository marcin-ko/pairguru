class Api::V2::MovieResource < JSONAPI::Resource
  attributes :title

  has_one :genre
end
