shared_examples 'when there is a problem in authorization' do
  it "returns 401 status if there is no access_token" do
    get "/api/v1/profiles/#{endpoint}", params: { format: :json }
    expect(response.status).to eq(401)
  end

  it "returns 401 status if access_token is invalid" do
    get "/api/v1/profiles/#{endpoint}", params: { format: :json, access_token: '1234' }
    expect(response.status).to eq(401)
  end
end

shared_examples 'when successfully authorized' do
  it 'returns 200 status' do
    expect(response).to be_success
  end
end
