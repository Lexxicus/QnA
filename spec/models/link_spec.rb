# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:gist_link) { create(:link, url: 'https://gist.github.com/Lexxicus/208fbcecfbb1eb6cb5422a1eaf727c8c') }
  let(:link) { create(:link) }

  it { should belong_to(:linkable) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }

  it 'return true if link include gist.github' do
    expect(gist_link.gist?).to eq true
  end

  it 'return false if link not include gist.github' do
    expect(link.gist?).to eq false
  end
end
