require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create_list(:user, 2) }
  let!(:question) { create(:question, user: user.first) }
  let!(:answer) { create(:answer, question: question, user: user.first) }

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: answer }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user.first) }

    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user.first) }

    it 'renders edit view' do
      get :edit, params: { id: answer }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user.first) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.to change(question.answers, :count).by(1)
      end
      it 'render create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'author update his own answer' do
      before { login(user.first) }

      context 'with valid attributes' do
        it 'change answer attributes' do
          patch :update,
                params: { id: answer, answer: { body: 'new body' }, question_id: question },
                format: :js

          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'redirect to updated question' do
          patch :update,
                params: { id: answer, answer: { body: 'new body' }, question_id: question },
                format: :js

          expect(response).to render_template :update
        end

        context 'with not valid attribute' do
          it "doesn't change answer" do
            patch :update,
                  params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question },
                  format: :js

            answer.reload
            expect(answer.body).to eq answer.body
          end
        end
      end
    end

    context 'nonauthor try to update answer' do
      before { login(user.last) }

      it "can't change it" do
        expect { patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }, format: :js }.to_not change(answer, :body)
      end

      it 'renders show view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js

        expect(response).to render_template 'answers/update'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      before { login(user.first) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'non-author' do
      before { login(user.last) }
      let!(:answer) { create(:answer) }

      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end

    context 'Unauthorized user' do
      let!(:answer) { create(:answer) }

      it 'not deletes the question' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    before { login(user.first) }

    it 'assign answer' do
      patch :mark_as_best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq(answer)
    end

    it 'author choose best answer' do
      patch :mark_as_best, params: { id: answer }, format: :js

      answer.reload
      expect(answer).to eq answer.question.best_answer
    end
  end
end
