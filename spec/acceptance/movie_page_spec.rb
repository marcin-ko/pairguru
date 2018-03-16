require "rails_helper"

RSpec.describe "Movie page" do
  describe "movies show" do
    let(:movie) { create(:movie) }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:comment) { movie.comments.create(commenter: other_user, text: "nice!") }

    context "when unauthenticated" do
      before do
        visit "/movies/#{movie.id}"
      end

      it "displays right title and comment list" do
        expect(page).to have_selector("h1", text: movie.title)
        expect(page).to have_selector("span.comment", text: "#{other_user.name} says: #{comment.text}")
      end

      it "doesn't show comment input" do
        expect(page).not_to have_selector("textarea.comment-text-input")
      end
    end

    context "when authenticated" do
      before do
        login_as(user, :scope => :user)
        visit "/movies/#{movie.id}"
      end

      it "displays right title and comment list" do
        expect(page).to have_selector("h1", text: movie.title)
        expect(page).to have_selector("span.comment", text: "#{other_user.name} says: #{comment.text}")
      end

      it "displays comment input" do
        expect(page).to have_selector("textarea.comment-text-input")
        expect(page).to have_selector(".post-comment")
      end

      it "allows adding one comment" do
        fill_in "comment[text]", with: "cool!"

        expect {
          click_button "Post"
        }.to change { movie.reload.comments.count }.by(1)

        fill_in "comment[text]", with: "I changed my mind, it's actually really bad"

        expect {
          click_button "Post"
        }.not_to change { movie.reload.comments.count }
        expect(page).to have_content("one comment per Movie")
      end
    end

    context "when authenticated and visiting movie with own comment" do
      before do
        login_as(user, :scope => :user)
        comment = movie.comments.create(commenter: user, text: "cool!")
        visit "/movies/#{movie.id}"
      end

      it "allows deleting own comment" do
        expect {
          click_link "delete"
        }.to change { movie.reload.comments.kept.count }.by(-1)
        expect(page).to have_content("Comment deleted successfully")
        expect(page).not_to have_content("cool!")
      end
    end
  end
end
