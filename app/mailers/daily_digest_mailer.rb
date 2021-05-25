# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('created_at > ?', 1.day.ago)

    mail to: user.email, subject: 'Daily Digest' if @questions.any?
  end
end
