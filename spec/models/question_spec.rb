require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should have_many(:answers) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(5) }

  context '#destroy' do
    before do
      @question = FactoryGirl.create(:question)
      2.times { FactoryGirl.create(:answer, question_id: @question.id) }
    end

    it 'destroys related asnwers' do
      expect { @question.destroy }.to change { Answer.count }.by(-2)
    end
  end
end
