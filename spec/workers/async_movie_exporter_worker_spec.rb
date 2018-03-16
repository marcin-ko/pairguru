require "rails_helper"
RSpec.describe AsyncMovieExporterWorker, type: :worker do
  let(:user) { create :user }
  let(:file_path) { "tmp/movies.csv" }

  it "exports movie" do
    movie_exporter = double("MovieExporter")
    expect(MovieExporter).to receive(:new).and_return(movie_exporter)
    expect(movie_exporter).to receive(:call).with(user, file_path)
    subject.perform(user.id, file_path)
  end
end
