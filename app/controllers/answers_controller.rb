class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_answers, only: %i[create update]

  def show; end

  def new; end

  def edit; end

  def create
    @question = answer.question
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: 'You successfully delete your answer.'
    else
      redirect_to question_path, error: "You cant't delete someone else's answer"
    end
  end

  def mark_as_best
    answer
    @question = answer.question
    @question.mark_as_best(answer) if current_user.author?(@question)
    load_answers
  end

  private

  def load_answers
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
    @best_answer ||= @question.best_answer
    @other_answers ||= @question.other_answers
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
