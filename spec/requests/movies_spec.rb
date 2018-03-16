require "rails_helper"

describe "Movies requests", type: :request do

  let!(:movie1) { create(:movie, title: "Godfather") }
  let!(:movie2) { create(:movie, title: "Kill Bill") }

  describe "movies list" do
    it "displays right title and movie links" do
      visit "/movies"
      expect(page).to have_selector("h1", text: "Movies")

      expect(page).to have_selector("a", text: "Godfather")
      expect(page).to have_selector("a", text: "Kill Bill")
    end
  end

  describe "movie page" do
    it "displays right title" do
      stub_request(:get, "https://pairguru-api.herokuapp.com/api/v1/movies/Kill%20Bill").
        to_return(status: 200, body: {
          data: {
            id: "6",
            type: "movie",
            attributes: {
              title: "Godfather",
              plot: "lorem ipsum",
              rating: 9.9,
              poster: "/godfather.jpg"
            }
          }
        }.to_json)

      visit "/movies/#{movie2.id}"
      expect(page).to have_selector("h1", text: "Kill Bill")
      expect(page).to have_selector(".description", text: "lorem ipsum")
      expect(page).to have_selector(".rating", text: "9.9")
      expect(page.find(".cover")["src"]).to eq("https://pairguru-api.herokuapp.com/godfather.jpg")
    end
  end
end
