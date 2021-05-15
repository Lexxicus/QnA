# frozen_string_literal: true

shared_examples_for 'API Destroyable' do
  context 'author delete his own resource' do
    it 'return 200 status' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(response).to be_successful
    end

    it 'delete question' do
      expect do
        delete api_path, params: { access_token: access_token.token }, headers: headers
      end.to change(model, :count).by(-1)
    end
  end

  context 'nonauthor can`t delete resource' do
    it 'return 403 status' do
      do_request(method, another_api_path, params: { access_token: access_token.token }, headers: headers)
      expect(response.status).to eq 403
    end

    it 'not delete question' do
      expect do
        delete api_path, params: { access_token: access_token.token }, headers: headers
      end.to_not change(model, :count)
    end
  end
end
