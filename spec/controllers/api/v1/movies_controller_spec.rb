require "rails_helper"

RSpec.describe Api::V1::MoviesController, type: :controller do
  describe "#index" do
    let!(:movie1) { create(:movie, title: "Godfather") }
    let!(:movie2) { create(:movie, title: "Kill Bill") }

    it "returns 200 with movies data" do
      get :index, format: :json

      expect(response.code).to eq("200")
      expect(json["data"].count).to eq(2)
      expect(json).to contain_exactly_jsonapi_resources("movies", [movie1, movie2].map(&:id))
    end

    it "paginates results" do
      create(:movie)
      get :index, format: :json, params: { page: { size: 2 } }
      expect(json["data"].count).to eq(2)
      expect(json["meta"]["total-count"]).to eq(3)
      expect(json["links"]["next"]).to eq(
        "http://test.host/api/v1/movies?#{{ page: { number: 2, size: 2 } }.to_query}"
      )
    end
  end

  describe "#show" do
    let!(:movie) { create(:movie, title: "Godfather") }

    it "returns 200 with movie data" do
      get :show, format: :json, params: { id: movie.id }

      expect(response.code).to eq("200")
      expect(json).to contain_exactly_jsonapi_resources("movies", movie.id)
      expect(json["data"]["attributes"]["title"]).to eq("Godfather")
    end
  end
end
