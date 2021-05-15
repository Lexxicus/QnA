# frozen_string_literal: true

shared_examples_for 'API Authorizable' do
  context 'unathorized' do
    it 'returns 401 status if there no acces_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if acces_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
