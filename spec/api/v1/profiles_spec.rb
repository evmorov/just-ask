require 'rails_helper'
require 'json'

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
        attr_value = me.send(attr.to_sym)
        attr_value = attr_value.iso8601(3) if %w(created_at updated_at).include? attr
        expect(response_body[attr]).to eq(attr_value)
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain #{attr}" do
        expect(response_body).to_not have_key(attr)
      end
    end
  end

  describe 'GET /index' do
    include_examples('when there is a problem in authorization') { let(:endpoint) { nil } }
    include_examples 'when successfully authorized'

    let!(:other_users) { create_list(:user, 3) }

    before do
      get '/api/v1/profiles', params: { format: :json, access_token: access_token.token }
    end

    it 'has proper number of users' do
      expect(response_body.size).to eq(other_users.size)
    end

    it "doesn't include me" do
      other_users.size.times do |user_number|
        expect(response_body[user_number]['id']).to_not eq(me.id)
      end
    end

    %w(id email created_at updated_at admin).each do |attr|
      it "the first user in the list of users has field #{attr}" do
        expect(response_body.first).to have_key(attr)
      end
    end

    %w(password encrypted_password).each do |attr|
      it "the first user in the list of users doesn't have field #{attr}" do
        expect(response_body.first).to_not have_key(attr)
      end
    end
  end
end
