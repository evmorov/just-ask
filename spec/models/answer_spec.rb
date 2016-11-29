require 'rails_helper'

describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }

  describe '#best_answer' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, best: false) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it "select the best answer if it's not" do
      answer.toggle_best
      expect(answer.best).to be(true)
    end

    it "unselect the best if it's already the best" do
      best_answer.toggle_best
      expect(best_answer.best).to be(false)
    end

    it 'set the best attribute and if there is another best answer makes it false' do
      answer.toggle_best
      best_answer.reload

      expect(best_answer.best).to be(false)
    end

    it 'unselects the best answer if it is already the best' do
      best_answer.toggle_best
      answer.reload

      expect(answer.best).to be(false)
    end
  end
end
