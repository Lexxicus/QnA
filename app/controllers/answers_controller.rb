# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]
  before_action :load_answers, only: %i[create update]
  after_action :publish_answer, only: [:create]
  helper_method :answer, :question

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
    answer.update(answer_params)
  end

  def destroy
    question.update!(best_answer: nil) if question.best_answer == answer
    answer.destroy
  end

  def mark_as_best
    answer
    @question = answer.question
    @question.mark_as_best(answer)
    load_answers
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("questions/#{@answer.question_id}",
                                 answer: @answer,
                                 email: @answer.user.email,
                                 created_at: @answer.created_at.strftime('%d.%m.%Y %H:%M:%S'),
                                 links: @answer.links)
  end

  def load_answers
    @best_answer ||= question.best_answer
    @other_answers ||= question.other_answers
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[id name url _destroy done])
  end
end
