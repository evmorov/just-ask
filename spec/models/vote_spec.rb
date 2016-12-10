require 'rails_helper'

describe Vote, type: :model do
  it { should belong_to :votable }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question) }

  describe '.upvote' do
    context 'when a votable does not have votes yet' do
      let(:vote) { Vote.upvote(user: user, votable: question) }

      it 'creates a Vote instance' do
        expect(vote).to be_a(Vote)
      end

      it 'creates a valid instance' do
        expect(vote).to be_valid
      end

      it 'votable has score = 1' do
        expect(vote.score).to eq(1)
      end
    end

    context 'when an upvote from another user exists for this votable' do
      let!(:vote_old) { Vote.upvote(user: another_user, votable: question) }
      let!(:vote_new) { Vote.upvote(user: user, votable: question) }

      it 'keeps the upvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'creates a new vote' do
        expect(Vote.exists?(vote_new.id)).to be(true)
      end
    end

    context 'when an upvote already exists for this user and this votable' do
      let!(:vote_old) { Vote.upvote(user: user, votable: question) }
      let!(:vote_new) { Vote.upvote(user: user, votable: question) }

      it 'keeps the upvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'does not create a new vote' do
        expect(vote_new).to be_nil
      end
    end

    context 'when a downvote already exists for this user and this votable' do
      let!(:downvote) { Vote.downvote(user: user, votable: question) }
      let!(:upvote) { Vote.upvote(user: user, votable: question) }

      it 'remove the downvote' do
        expect(Vote.exists?(downvote.id)).to be(false)
      end

      it 'creates a new vote' do
        expect(Vote.exists?(upvote.id)).to be(true)
      end
    end
  end

  describe '.downvote' do
    context 'when votable does not have votes yet' do
      let(:vote) { Vote.downvote(user: user, votable: question) }

      it 'creates a Vote instance' do
        expect(vote).to be_a(Vote)
      end

      it 'creates a valid instance' do
        expect(vote).to be_valid
      end

      it 'votable has score = -1' do
        expect(vote.score).to eq(-1)
      end
    end

    context 'when a downvote from another user exists for this votable' do
      let!(:vote_old) { Vote.downvote(user: another_user, votable: question) }
      let!(:vote_new) { Vote.downvote(user: user, votable: question) }

      it 'keeps the downvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'creates a new vote' do
        expect(Vote.exists?(vote_new.id)).to be(true)
      end
    end

    context 'when an downvote already exists for this user and this votable' do
      let!(:vote_old) { Vote.downvote(user: user, votable: question) }
      let!(:vote_new) { Vote.downvote(user: user, votable: question) }

      it 'keeps the downvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'does not create a new vote' do
        expect(vote_new).to be_nil
      end
    end

    context 'when a upvote already exists for this user and this votable' do
      let!(:upvote) { Vote.upvote(user: user, votable: question) }
      let!(:downvote) { Vote.downvote(user: user, votable: question) }

      it 'remove the upvote' do
        expect(Vote.exists?(upvote.id)).to be(false)
      end

      it 'creates a new vote' do
        expect(Vote.exists?(downvote.id)).to be(true)
      end
    end
  end
end
