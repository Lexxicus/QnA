# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  helper_method :commentable
  after_action  :publish_comment, only: %i[create]

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      format.js { render partial: 'comments/add_comment', layout: false } if @comment.save
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render partial: 'comments/destroy_comment', layout: false
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments/#{question_id}", comment: @comment, user: current_user.email)
  end

  def commentable_id
    params["#{params[:commentable]}_id".to_sym]
  end

  def commentable
    params[:commentable].classify.constantize.find(commentable_id)
  end

  def question_id
    commentable.is_a?(Question) ? commentable.id : commentable.question.id
  end
end
