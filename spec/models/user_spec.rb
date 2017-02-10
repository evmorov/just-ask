require 'rails_helper'

describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of' do
    let(:user) { create(:user) }

    it 'returns true if an argument belongs to User' do
      question = create(:question, user: user)
      expect(user).to be_author_of(question)
    end

    it 'returns false if an argument from another User' do
      question = create(:question)
      expect(user).to_not be_author_of(question)
    end
  end

  describe '.create_if_not_exist_w_auth' do
    let(:user) { create(:user) }

    it 'matches user by email and returns him' do
      user_found = User.create_if_not_exist_w_auth(user.email, 'twitter', '123456')
      expect(user_found).to eq(user)
    end

    it "creates a new user if a user can't be found by email" do
      user_created = User.create_if_not_exist_w_auth('new_mail@twitter.com', 'Twitter', '123456')
      expect(user_created.email).to eq('new_mail@twitter.com')
    end

    it 'creates authorization' do
      user_found = User.create_if_not_exist_w_auth(user.email, 'twitter', '123456')
      expect(user_found.authorizations.first.provider).to eq('twitter')
      expect(user_found.authorizations.first.uid).to eq('123456')
    end
  end

  describe '.find_by_auth' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    it 'returns user found by authorization' do
      user.authorizations.create(provider: 'facebook', uid: '123456')
      user_found = User.find_by_auth(auth)
      expect(user_found).to eq(user)
    end

    it 'returns nil if user not found' do
      user_found = User.find_by_auth(auth)
      expect(user_found).to be_nil
    end
  end
end
