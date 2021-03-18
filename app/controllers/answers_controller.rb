class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  def show; end

  def new; end

  def edit; end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    @question = answer.question
    if answer.update(answer_params)
      redirect_to question_path(answer.question)
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: 'You successfully delete your answer.'
    else
      redirect_to question_path, error: "You cant't delete someone else's answer"
    end
  end

  private

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
