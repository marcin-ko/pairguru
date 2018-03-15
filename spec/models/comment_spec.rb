require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    let(:movie) { create(:movie) }
    let(:user) { create(:user) }

    context 'when commenter and commentable are present and valid' do
      before do
        subject.commentable = movie
        subject.commenter = user
      end

      it 'checks for text emptiness' do
        subject.text = ''
        expect(subject).not_to be_valid
        expect(subject.errors[:text]).to contain_exactly("can't be blank", "is too short (minimum is 3 characters)")
      end

      it 'checks for text length' do
        subject.text = 'oh'
        expect(subject).not_to be_valid
        expect(subject.errors[:text]).to contain_exactly("is too short (minimum is 3 characters)")
      end

      it 'is valid when text is long enough' do
        subject.text = 'cool'
        expect(subject).to be_valid
      end
    end

    context 'when commentable is empty' do
      before do
        subject.commenter = user
        subject.text = 'cool'
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:commentable]).to contain_exactly("can't be blank")
      end
    end

    context 'when commenter is empty' do
      before do
        subject.commentable = movie
        subject.text = 'cool'
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:commenter]).to contain_exactly("can't be blank")
      end
    end

    context 'when commenter already commented on the same movie' do
      before do
        create(:comment, commentable: movie, commenter: user)
        subject.commentable = movie
        subject.commenter = user
        subject.text = 'cool'
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:commenter_id]).to contain_exactly("one comment per Movie")
      end
    end
  end
end
