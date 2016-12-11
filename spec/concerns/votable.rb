require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes) }

  it { should accept_nested_attributes_for :votes }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:votable) { create(described_class.to_s.underscore.to_sym, user: user) }

  describe '#upvote' do
    context 'when a votable does not have votes yet' do
      let(:vote) { votable.upvote(user.id) }

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
      let!(:vote_old) { votable.upvote(another_user.id) }
      let!(:vote_new) { votable.upvote(user.id) }

      it 'keeps the upvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'creates a new vote' do
        expect(Vote.exists?(vote_new.id)).to be(true)
      end
    end

    context 'when an upvote already exists for this user and this votable' do
      let!(:vote_old) { votable.upvote(user.id) }
      let!(:vote_new) { votable.upvote(user.id) }

      it 'keeps the upvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'does not create a new vote' do
        expect(vote_new).to be_nil
      end
    end

    context 'when a downvote already exists for this user and this votable' do
      let!(:downvote) { votable.downvote(user.id) }
      let!(:upvote) { votable.upvote(user.id) }

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
      let(:vote) { votable.downvote(user.id) }

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
      let!(:vote_old) { votable.downvote(another_user.id) }
      let!(:vote_new) { votable.downvote(user.id) }

      it 'keeps the downvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'creates a new vote' do
        expect(Vote.exists?(vote_new.id)).to be(true)
      end
    end

    context 'when an downvote already exists for this user and this votable' do
      let!(:vote_old) { votable.downvote(user.id) }
      let!(:vote_new) { votable.downvote(user.id) }

      it 'keeps the downvote that exists' do
        expect(Vote.exists?(vote_old.id)).to be(true)
      end

      it 'does not create a new vote' do
        expect(vote_new).to be_nil
      end
    end

    context 'when a upvote already exists for this user and this votable' do
      let!(:upvote) { votable.upvote(user.id) }
      let!(:downvote) { votable.downvote(user.id) }

      it 'remove the upvote' do
        expect(Vote.exists?(upvote.id)).to be(false)
      end

      it 'creates a new vote' do
        expect(Vote.exists?(downvote.id)).to be(true)
      end
    end
  end

  describe '#total_score' do
    it 'is zero when no votes' do
      expect(votable.votes).to be_empty
      expect(votable.total_score).to eq(0)
    end

    it 'has positive value when there are more upvotes' do
      10.times { votable.upvote(create(:user).id) }
      5.times { votable.downvote(create(:user).id) }

      expect(votable.total_score).to eq(5)
    end

    it 'has negative value when there are more downvotes' do
      5.times { votable.upvote(create(:user).id) }
      10.times { votable.downvote(create(:user).id) }

      expect(votable.total_score).to eq(-5)
    end
  end

  describe '#vote_state' do
    it 'returns "upvoted" when the user upvoted the votable' do
      votable.upvote(user.id)

      expect(votable.vote_state(user.id)).to eq('upvoted')
    end

    it 'returns "downvoted" when the user downvoted the votable' do
      votable.downvote(user.id)

      expect(votable.vote_state(user.id)).to eq('downvoted')
    end

    it 'returns nil when the user did not give his vote' do
      expect(votable.vote_state(user.id)).to be_nil
    end
  end
end
