require 'rails_helper'

describe 'Sidekiq Web UI', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  it 'administrator can open the monitor page' do
    sign_in admin
    get sidekiq_web_path

    expect(response).to have_http_status(:success)
  end

  it "user can't open the monitor page" do
    sign_in user

    expect {
      get sidekiq_web_path
    }.to raise_error(ActionController::RoutingError)
  end
end
