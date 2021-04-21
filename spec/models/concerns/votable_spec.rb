# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  it 'should create rating with vote = 1' do
    expect { model.vote_up(user) }.to change(Vote, :count).by(1)
    expect(model.votes.first.vote).to eq 1
  end

  it 'should create rating with vote = -1' do
    expect { model.vote_down(user) }.to change(Vote, :count).by(1)
    expect(model.votes.first.vote).to eq(-1)
  end

  it 'should cancel rating = remove it' do
    model.vote_up(user)
    expect { model.cancel_vote(user) }.to change(Vote, :count).by(-1)
  end

  it 'should correctly back a rating' do
    expect { model.vote_up(user) }.to change { model.rating }.by(1)
  end
end
