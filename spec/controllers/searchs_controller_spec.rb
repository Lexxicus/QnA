# frozen_string_literal: true

require 'sphinx_helper'

RSpec.describe SearchsController, type: :controller do
  describe 'GET #search' do
    let!(:question) { create(:question, title: 'First question') }

    it 'assigns the requested search to @search_params' do
      get :search, params: { query: 'test search', resource: 'All' }
      expect(assigns(:search_params)).to eq('query' => 'test search', 'resource' => 'All')
    end

    it 'the search engine responds for ALL query' do
      allow(ThinkingSphinx).to receive(:search).with('test search')
      get :search, params: { query: 'test search', resource: 'All' }
    end

    it 'the search engine responds for ALL  query and return data' do
      allow(ThinkingSphinx).to receive(:search).with('First').and_return(question)
      get :search, params: { query: 'First', resource: 'All' }
    end

    it 'redirect to root if options is empty' do
      get :search, params: { query: 'test', resource: '' }
      expect(response).to redirect_to root_path
    end

    it 'render to Search if query is not empty' do
      get :search, params: { query: 'test', resource: 'All' }
      expect(response).to render_template :search
    end
  end
end
