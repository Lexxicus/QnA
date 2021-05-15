# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      helper_method :question, :answer

      authorize_resource class: Answer

      def index
        @answers = question.answers
        render json: @answers
      end

      def show
        render json: answer
      end

      def create
        @answer = question.answers.new(answer_params)
        @answer.user = current_resource_owner
        if @answer.save
          render json: @answer
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def update
        if answer.update(answer_params)
          render json: answer
        else
          render json: { errors: answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, answer
        if answer.destroy
          head :ok
        else
          render json: { errors: answer.errors }, status: :unprocessable_entity
        end
      end

      private

      def answer
        @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
      end

      def question
        @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
