require "rails_helper"

RSpec.describe TopCommentersController, type: :controller do

  describe "GET #index" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }
    let(:user5) { create(:user) }

    before do
      10.times do |i|
        user5.comments.create!(commentable: create(:movie), text: "cool", created_at: (10+i).days.ago) # 0 comments in last 7 days
        user4.comments.create!(commentable: create(:movie), text: "cool", created_at: (8+i).days.ago) # 0 comments in last 7 days
        user3.comments.create!(commentable: create(:movie), text: "cool", created_at: (4+i).days.ago) # 3 comments in last 7 days
        user2.comments.create!(commentable: create(:movie), text: "cool", created_at: (2+i).days.ago) # 5 comments in last 7 days
        user1.comments.create!(commentable: create(:movie), text: "cool", created_at: i.days.ago) # 7 comments in last 7 days
      end
    end

    it "returns top commenters" do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:commenters)).to eq([user1, user2, user3])
    end
  end
end
