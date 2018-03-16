require "rails_helper"

RSpec.describe Api::V2::MoviesController, type: :controller do
  describe "#index" do
    let!(:movie1) { create(:movie, title: "Godfather") }
    let!(:movie2) { create(:movie, title: "Kill Bill") }

    it "returns 200 with movies data and genre included" do
      get :index, format: :json, params: { include: "genre" }

      expect(response.code).to eq("200")
      expect(json["data"].count).to eq(2)
      expect(json).to contain_exactly_jsonapi_resources("movies", [movie1, movie2].map(&:id))
      expect(json).to have_jsonapi_included_objects("genres", [movie1.genre, movie2.genre].map(&:id))
    end

    it "paginates results" do
      create(:movie)
      get :index, format: :json, params: { page: { size: 2 } }
      expect(json["data"].count).to eq(2)
      expect(json["meta"]["total-count"]).to eq(3)
      expect(json["links"]["next"]).to eq(
        "http://test.host/api/v2/movies?#{{ page: { number: 2, size: 2 } }.to_query}"
      )
    end
  end

  describe "#show" do
    let(:genre) { create(:genre, name: "action") }
    let!(:movie) { create(:movie, title: "Godfather", genre: genre) }
    let!(:other_movie) { create(:movie, title: "Kill Bill", genre: genre) }

    it "returns 200 with movie data and genre included" do
      get :show, format: :json, params: { id: movie.id, include: "genre" }

      expect(response.code).to eq("200")
      expect(json).to contain_exactly_jsonapi_resources("movies", movie.id)
      expect(json["data"]["attributes"]["title"]).to eq("Godfather")
      expect(json["included"][0]["type"]).to eq("genres")
      expect(json["included"][0]["attributes"]["name"]).to eq("action")
      expect(json["included"][0]["attributes"]["movies-count"]).to eq(2)
    end
  end
end
