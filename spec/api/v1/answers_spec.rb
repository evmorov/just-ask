require 'rails_helper'

describe 'Answers API' do
  let(:resource_owner) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }

  describe 'GET /index' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 2, question: question) }
    let!(:answer) { answers.first }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      before do
        get(
          "/api/v1/questions/#{question.id}/answers",
          params: { format: :json, access_token: access_token.token }
        )
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'number of answers' do
        expect(response_body['answers'].size).to eq(answers.size)
      end

      %w(id body).each do |attr|
        it "contains #{attr}" do
          expect(response_body['answers'].first[attr]).to eq(answer.send(attr))
        end
      end

      %w(created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expected_value = answer.send(attr).iso8601(3)
          expect(response_body['answers'].first[attr]).to eq(expected_value)
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      before do
        get(
          "/api/v1/answers/#{answer.id}",
          params: { format: :json, access_token: access_token.token }
        )
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body).each do |attr|
        it "contains #{attr}" do
          expect(response_body['answer'][attr]).to eq(answer.send(attr))
        end
      end

      %w(created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expected_value = answer.send(attr).iso8601(3)
          expect(response_body['answer'][attr]).to eq(expected_value)
        end
      end

      context 'comments' do
        it 'has list of comments' do
          expect(response_body['answer']['comments'].size).to eq(answer.comments.size)
        end

        %w(id body commentable_type commentable_id).each do |attr|
          it "contains #{attr}" do
            expected_value = answer.comments.first.send(attr)
            expect(response_body['answer']['comments'].first[attr]).to eq(expected_value)
          end
        end

        %w(created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expected_value = answer.comments.first.send(attr).iso8601(3)
            expect(response_body['answer']['comments'].first[attr]).to eq(expected_value)
          end
        end
      end

      context 'attachments' do
        it 'has list of attachments' do
          expect(response_body['answer']['attachments'].size).to eq(answer.attachments.size)
        end

        %w(id attachable_id attachable_type).each do |attr|
          it "contains #{attr}" do
            expected_value = answer.attachments.first.send(attr)
            expect(response_body['answer']['attachments'].last[attr]).to eq(expected_value)
          end
        end

        it 'contains file url' do
          expected_value = answer.attachments.first.file_url
          expect(response_body['answer']['attachments'].last['file']['url']).to eq(expected_value)
        end

        %w(created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expected_value = answer.attachments.first.send(attr).iso8601(3)
            expect(response_body['answer']['attachments'].last[attr]).to eq(expected_value)
          end
        end
      end
    end
  end

  describe 'POST /create' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post("/api/v1/questions/#{question.id}/answers", params: {
          answer: attributes_for(:answer),
          format: :json
        })
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        post("/api/v1/questions/#{question.id}/answers", params: {
          answer: attributes_for(:answer),
          format: :json,
          access_token: '1234'
        })
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 200 status' do
          post("/api/v1/questions/#{question.id}/answers", params: {
            answer: attributes_for(:answer),
            format: :json,
            access_token: access_token.token
          })
          expect(response).to be_success
        end

        it 'saves the new answer with the resource owner' do
          expect {
            post("/api/v1/questions/#{question.id}/answers", params: {
              answer: attributes_for(:answer),
              format: :json,
              access_token: access_token.token
            })
          }.to change(resource_owner.answers, :count).by(1)
        end

        it 'saves the new answer with the exact question' do
          expect {
            post("/api/v1/questions/#{question.id}/answers", params: {
              answer: attributes_for(:answer),
              format: :json,
              access_token: access_token.token
            })
          }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect {
            post("/api/v1/questions/#{question.id}/answers", params: {
              answer: attributes_for(:invalid_answer),
              format: :json,
              access_token: access_token.token
            })
          }.to_not change(Answer, :count)
        end

        it 'returns 422 status' do
          post("/api/v1/questions/#{question.id}/answers", params: {
            answer: attributes_for(:invalid_answer),
            format: :json,
            access_token: access_token.token
          })
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
