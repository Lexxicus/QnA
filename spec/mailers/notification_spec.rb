require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'send_notification' do
    let!(:question) { create(:question) }
    let!(:answer)   { create(:answer, question: question) }
    let!(:user)     { create(:user) }
    let(:mail)      { NotificationMailer.new_answer_notification(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq("You've got a new answer to your question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content('New answer on your question:')
    end
  end
end
