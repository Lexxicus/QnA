# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_subscription, only: %i[show update]
  after_action :publish_question, only: [:create]
  helper_method :question

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @best_answer = question.best_answer
    @other_answers = question.other_answers
    set_gon
  end

  def new
    question.links.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question succeffully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted!'
  end

  private

  def set_gon
    gon.question_id = @question.id
    gon.current_user_id = current_user&.id
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: {
          question: @question
        }
      )
    )
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def set_subscription
    @subscription ||= current_user&.subscriptions&.find_by(question: question)
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[id name url _destroy done],
                                     reward_attributes: %i[id title image])
  end
end
