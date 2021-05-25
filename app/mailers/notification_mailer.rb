# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def new_answer_notification(user, answer)
    @question = answer.question
    @answer = answer

    mail to: user.email, subject: "You've got a new answer to your question"
  end
end
