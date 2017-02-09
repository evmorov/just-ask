require 'rails_helper'

describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:questions_ids) { create_list(:question, 2, user: users.first).map(&:id) }

  it 'sends daily digest for each user' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user, questions_ids).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
