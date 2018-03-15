require 'rails_helper'

RSpec.describe MovieAPIClient do
  subject { described_class.new(movie_name: 'Godfather') }

  describe 'movie_json' do
    it 'fetches movie json from api' do
      expect(subject).to receive(:get_movie_json).and_return({
        'data': {
          'id': '1',
          'type': 'movie',
          'attributes': {
            'title': 'Godfather',
            'rating': 9.2
          }
        }
      })
      subject.call
      expect(subject.movie_json[:data][:id]).to eq('1')
      expect(subject.movie_json[:data][:attributes][:title]).to eq('Godfather')
    end

    context 'when unknown movie title' do
      subject { described_class.new(movie_name: 'godfather') }
      it 'raises error' do
        expect(subject).to receive(:fetch_movie_api).and_raise(OpenURI::HTTPError.new('404 Not Found', nil))
        expect(Rails.logger).to receive(:warn).with('Error when fetching movie json for title: godfather - 404 Not Found')
        subject.call
        expect(subject.movie_json).to be_nil
      end
    end
  end
end
