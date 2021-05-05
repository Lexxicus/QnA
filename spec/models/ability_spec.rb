# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question}
    it { should be_able_to :read, Answer}
    it { should be_able_to :read, Comment}

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other }
    let(:answer) { create :answer, question: question, user: user }
    let(:other_answer) { create :answer, question: question, user: other }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, other_question }

      it { should be_able_to %i[vote_up vote_down], other_question }
      it { should_not be_able_to %i[vote_up vote_down], question }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, other_answer }

      it { should be_able_to %i[vote_up vote_down], other_answer }
      it { should_not be_able_to %i[vote_up vote_down], answer }

      it { should be_able_to :mark_as_best, answer }
      it { should_not be_able_to :mark_as_best, create(:answer, question: other_question) }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end
  end
end
