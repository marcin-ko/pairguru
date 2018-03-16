require "rails_helper"
RSpec.describe AsyncMovieInfoSenderWorker, type: :worker do
  let(:user) { create :user }
  let(:movie) { create :movie }

  it "exports movie" do
    mail = double("movie mail")
    expect(MovieInfoMailer).to receive(:send_info).with(user, movie).and_return(mail)
    expect(mail).to receive("deliver_now")
    subject.perform(user.id, movie.id)
  end
end
