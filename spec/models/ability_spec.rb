require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :admin }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      let(:my_question) { create(:question, user: user) }
      let(:not_my_question) { create(:question, user: another_user) }

      it { should be_able_to :create, Question }

      it { should be_able_to :update, my_question }
      it { should_not be_able_to :update, not_my_question }

      it { should be_able_to :destroy, my_question }
      it { should_not be_able_to :destroy, not_my_question }

      it { should be_able_to :upvote, not_my_question }
      it { should_not be_able_to :upvote, my_question }

      it { should be_able_to :downvote, not_my_question }
      it { should_not be_able_to :downvote, my_question }
    end

    context 'Answer' do
      let(:my_question) { create(:question, user: user) }
      let(:my_answer) { create(:answer, question: my_question, user: user) }
      let(:not_my_answer) { create(:answer, question: my_question, user: another_user) }

      let(:not_my_question) { create(:question, user: another_user) }
      let(:my_answer_not_my_question) { create(:answer, question: not_my_question, user: user) }

      it { should be_able_to :create, Answer }

      it { should be_able_to :update, my_answer }
      it { should_not be_able_to :update, not_my_answer }

      it { should be_able_to :destroy, my_answer }
      it { should_not be_able_to :destroy, not_my_answer }

      it { should be_able_to :upvote, not_my_answer }
      it { should_not be_able_to :upvote, my_answer }

      it { should be_able_to :downvote, not_my_answer }
      it { should_not be_able_to :downvote, my_answer }

      it { should be_able_to :best, my_answer }
      it { should be_able_to :best, not_my_answer }
      it { should_not be_able_to :best, my_answer_not_my_question }
    end

    context 'Comment' do
      let(:my_comment) { create(:comment, user: user) }
      let(:not_my_comment) { create(:comment, user: another_user) }

      it { should be_able_to :create, Comment }

      it { should be_able_to :update, my_comment }
      it { should_not be_able_to :update, not_my_comment }

      it { should be_able_to :destroy, my_comment }
      it { should_not be_able_to :destroy, not_my_comment }
    end

    context 'Attachment' do
      let(:my_attachable) { create(:question, user: user) }
      let(:my_attachment) { create(:attachment, attachable: my_attachable) }
      let(:not_my_attachable) { create(:question, user: another_user) }
      let(:not_my_attachment) { create(:attachment, attachable: not_my_attachable) }

      it { should be_able_to :destroy, my_attachment }
      it { should_not be_able_to :destroy, not_my_attachment }
    end

    context 'API' do
      it { should be_able_to :me, User }
    end
  end
end
