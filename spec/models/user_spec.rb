# rubocop:disable Layout/MultilineMethodCallIndentation

require 'rails_helper'

describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
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

  describe '.create_user_and_auth' do
    let(:auth) { { email: 'auth@mail.com', username: 'authname', provider: 'Twitter', uid: '321' } }

    it 'returns User object' do
      expect(User.create_user_and_auth(auth)).to be_a(User)
    end

    it 'creates User' do
      expect { User.create_user_and_auth(auth) }.to change(User, :count).by(1)
    end

    it 'creates Authorization' do
      expect { User.create_user_and_auth(auth) }.to change(Authorization, :count).by(1)
    end

    it "doesn't create anything if there is already user with such email" do
      create(:user, email: auth[:email])
      expect {
        User.create_user_and_auth(auth)
      }.to raise_error(ActiveRecord::RecordInvalid)
        .and change(User, :count).by(0)
        .and change(Authorization, :count).by(0)
    end

    it "doesn't create anything if there is already user with such username" do
      create(:user, username: auth[:username])
      expect {
        User.create_user_and_auth(auth)
      }.to raise_error(ActiveRecord::RecordInvalid)
        .and change(User, :count).by(0)
        .and change(Authorization, :count).by(0)
    end

    context 'when auth is not valid' do
      it "doesn't create anything if no email" do
        expect {
          User.create_user_and_auth(username: 'authname', provider: 'Twitter', uid: '321')
        }.to raise_error(ActiveRecord::RecordInvalid)
          .and change(User, :count).by(0)
          .and change(Authorization, :count).by(0)
      end

      it "doesn't create anything if no username" do
        expect {
          User.create_user_and_auth(email: 'auth@mail.com', provider: 'Twitter', uid: '321')
        }.to raise_error(ActiveRecord::RecordInvalid)
          .and change(User, :count).by(0)
          .and change(Authorization, :count).by(0)
      end

      it "doesn't create anything if no provider" do
        expect {
          User.create_user_and_auth(email: 'auth@mail.com', username: 'authname', uid: '321')
        }.to raise_error(ActiveRecord::RecordInvalid)
          .and change(User, :count).by(0)
          .and change(Authorization, :count).by(0)
      end

      it "doesn't create anything if no uid" do
        expect {
          User.create_user_and_auth(email: 'me@mail.com', username: 'authname', provider: 'Twitter')
        }.to raise_error(ActiveRecord::RecordInvalid)
          .and change(User, :count).by(0)
          .and change(Authorization, :count).by(0)
      end
    end
  end
end

# rubocop:enable Layout/MultilineMethodCallIndentation
