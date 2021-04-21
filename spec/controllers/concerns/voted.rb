# frozen_string_literal: true

RSpec.shared_examples 'voted' do
  context 'POST #vote_up, #vote_down' do
    before { login(test_user) }

    it 'create a new vote' do
      expect { patch :vote_up, params: { id: voted } }.to change(Vote, :count).by(1)
    end

    it 'create a new vote' do
      expect { patch :vote_down, params: { id: voted } }.to change(Vote, :count).by(1)
    end
  end

  context 'cancel vote' do
    before do
      login(test_user)
      voted.vote_up(test_user)
    end

    it 'destroy rating' do
      expect { patch :vote_up, params: { id: voted } }.to change(Vote, :count).by(-1)
    end
  end
end
