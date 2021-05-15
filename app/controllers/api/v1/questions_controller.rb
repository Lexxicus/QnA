# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      helper_method :question

      authorize_resource class: Question

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionsSerializer
      end

      def show
        render json: question
      end

      def create
        @question = current_resource_owner.questions.new(question_params)
        if @question.save
          render json: @question
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def update
        if question.update(question_params)
          render json: question
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if question.destroy
          render json: question
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      private

      def question
        @question ||= Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
