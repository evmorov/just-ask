require 'rails_helper'

describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

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

    it 'raises NoMethodError if an argument does not repond to #user_id' do
      expect { user.author_of? [] }.to raise_error(NoMethodError)
    end
  end
end
