require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /me' do
    include_examples('when there is a problem in authorization') { let(:endpoint) { 'me' } }
    include_examples 'when successfully authorized'

    before do
      get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
    end

    %w(id email created_at updated_at admin).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

  describe 'GET /users' do
    include_examples('when there is a problem in authorization') { let(:endpoint) { 'users' } }
    include_examples 'when successfully authorized'

    let!(:other_users) { create_list(:user, 3) }

    before do
      get '/api/v1/profiles/users', params: { format: :json, access_token: access_token.token }
    end

    it 'has proper number of users' do
      expect(response.body).to have_json_size(other_users.size)
    end

    it "doesn't include me" do
      other_users.size.times do |user_number|
        expect(response.body).to_not be_json_eql(me.id.to_json).at_path("#{user_number}/id")
      end
    end

    %w(id email created_at updated_at admin).each do |attr|
      it "the first user in the list of users has field #{attr}" do
        expect(response.body).to have_json_path("0/#{attr}")
      end
    end

    %w(password encrypted_password).each do |attr|
      it "the first user in the list of users doesn't have field #{attr}" do
        expect(response.body).to_not have_json_path("0/#{attr}")
      end
    end
  end
end
