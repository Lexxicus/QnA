# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  context 'user is author?' do
    it 'is true' do
      expect(question.user).to be_author(question)
    end

    it 'is false' do
      expect(user).to_not be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOautService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
