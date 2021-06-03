# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'lexx-03@mail.ru'
  layout 'mailer'
end
