require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:reward) { create(:reward, question: question, user: question.user) }

  describe 'GET#index' do
    before do
      login(question.user)
      get :index
    end

    it 'assigns awards equal to user rewards' do
      expect(assigns(:rewards)).to eq question.user.rewards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
