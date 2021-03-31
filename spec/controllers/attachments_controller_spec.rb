# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:users) { create(:user) }
  let(:question_with_file) { create(:question_with_file) }

  describe 'DELETE #destroy' do
    before do
      login(question_with_file.user)
    end

    it 'delete the file' do
      expect do
        delete :destroy,
               params: { id: question_with_file.files[0] },
               format: :js
      end.to change(question_with_file.files, :count).by(-1)
    end

    it 'render delete_attachment' do
      delete :destroy, params: { id: question_with_file.files[0] }, format: :js
      expect(response).to render_template :destroy
    end

    context 'user is not author of the question' do
      before { login(users) }
      it "can't delete file" do
        expect do
          delete :destroy,
                 params: { id: question_with_file.files[0] },
                 format: :js
        end.to change(question_with_file.files, :count).by(0)
      end
    end
  end
end
