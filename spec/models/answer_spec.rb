# frozen_string_literal: true

require 'rails_helper'
require_relative './concerns/votable_spec'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let(:question) { create(:question, user: another_user) }
    let(:model) { create(:answer, question: question, user: another_user) }
  end
end
