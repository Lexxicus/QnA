# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:me) { create(:user) }
  let(:method) { :get }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let!(:users) { create_list(:user, 3) }
    let(:user_response) { json['users'].first }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like 'API Authorizable'

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'users list do not contains Current_user' do
      json['users'].each do |item|
        expect(item['id']).to_not eq me.id
      end
    end

    it 'return users list' do
      expect(json['users'].size).to eq 3
    end

    it 'returns public fields' do
      %w[id email created_at updated_at].each do |attr|
        expect(user_response[attr]).to eq users.first.send(attr).as_json
      end
    end

    it 'does not returns private fields' do
      %w[password encrypted_password].each do |attr|
        expect(user_response).to_not have_key(attr)
      end
    end
  end
end
