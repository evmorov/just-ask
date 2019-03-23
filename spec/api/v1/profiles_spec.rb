require 'rails_helper'

describe 'Profile API' do
  let(:resource_owner) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }

  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      before do
        get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w[id email admin].each do |attr|
        it "contains #{attr}" do
          expect(response_body[attr]).to eq(resource_owner.send(attr))
        end
      end

      %w[created_at updated_at].each do |attr|
        it "contains #{attr}" do
          expect(response_body[attr]).to eq(resource_owner.send(attr).iso8601(3))
        end
      end

      %w[password encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response_body).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    let!(:other_users) { create_list(:user, 3) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      before do
        get '/api/v1/profiles', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'has proper number of users' do
        expect(response_body.size).to eq(other_users.size)
      end

      it "doesn't include resource owner" do
        other_users.size.times do |user_number|
          expect(response_body[user_number]['id']).to_not eq(resource_owner.id)
        end
      end

      %w[id email admin].each do |attr|
        it "the first user in the list of users has field #{attr}" do
          expect(response_body.first[attr]).to eq(other_users.first.send(attr))
        end
      end

      %w[created_at updated_at].each do |attr|
        it "the first user in the list of users has field #{attr}" do
          expected_value = other_users.first.send(attr).iso8601(3)
          expect(response_body.first[attr]).to eq(expected_value)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "the first user in the list of users doesn't have field #{attr}" do
          expect(response_body.first).to_not have_key(attr)
        end
      end
    end
  end
end
