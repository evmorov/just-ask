require 'rails_helper'

describe 'Questions API' do
  let(:resource_owner) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }

  describe 'GET /index' do
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.first }
    let!(:answer) { create(:answer, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      before do
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response_body['questions'].size).to eq(questions.size)
      end

      %w(id title body).each do |attr|
        it "question object contains #{attr}" do
          expect(response_body['questions'].first[attr]).to eq(question.send(attr))
        end
      end

      %w(created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response_body['questions'].first[attr]).to eq(question.send(attr).iso8601(3))
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      before do
        get(
          "/api/v1/questions/#{question.id}",
          params: { format: :json, access_token: access_token.token }
        )
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body).each do |attr|
        it "contains #{attr}" do
          expect(response_body['question'][attr]).to eq(question.send(attr))
        end
      end

      %w(created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response_body['question'][attr]).to eq(question.send(attr).iso8601(3))
        end
      end

      context 'comments' do
        it 'has list of comments' do
          expect(response_body['question']['comments'].size).to eq(question.comments.size)
        end

        %w(id body commentable_type commentable_id).each do |attr|
          it "contains #{attr}" do
            expected_value = question.comments.first.send(attr)
            expect(response_body['question']['comments'].first[attr]).to eq(expected_value)
          end
        end

        %w(created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expected_value = question.comments.first.send(attr).iso8601(3)
            expect(response_body['question']['comments'].first[attr]).to eq(expected_value)
          end
        end
      end

      context 'attachments' do
        it 'has list of attachments' do
          expect(response_body['question']['attachments'].size).to eq(question.attachments.size)
        end

        %w(id attachable_id attachable_type).each do |attr|
          it "contains #{attr}" do
            expected_value = question.attachments.first.send(attr)
            expect(response_body['question']['attachments'].last[attr]).to eq(expected_value)
          end
        end

        it 'contains file url' do
          expected_value = question.attachments.first.file_url
          expect(response_body['question']['attachments'].last['file']['url']).to eq(expected_value)
        end

        %w(created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expected_value = question.attachments.first.send(attr).iso8601(3)
            expect(response_body['question']['attachments'].last[attr]).to eq(expected_value)
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions/', params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        post(
          '/api/v1/questions/', params: {
            question: attributes_for(:question),
            format: :json,
            access_token: '1234'
          }
        )
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 200 status' do
          post(
            '/api/v1/questions/', params: {
              question: attributes_for(:question),
              format: :json,
              access_token: access_token.token
            }
          )
          expect(response).to be_success
        end

        it 'saves the new question with the resource owner' do
          expect {
            post(
              '/api/v1/questions/', params: {
                question: attributes_for(:question),
                format: :json,
                access_token: access_token.token
              }
            )
          }.to change(resource_owner.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect {
            post(
              '/api/v1/questions/', params: {
                question: attributes_for(:invalid_question),
                format: :json,
                access_token: access_token.token
              }
            )
          }.to_not change(Question, :count)
        end

        it 'returns 422 status' do
          post(
            '/api/v1/questions/', params: {
              question: attributes_for(:invalid_question),
              format: :json,
              access_token: access_token.token
            }
          )
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
