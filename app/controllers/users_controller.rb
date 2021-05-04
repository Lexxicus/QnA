# frozen_string_literal: true

class UsersController < ApplicationController
  def recieve_email
    @user = User.new
  end

  def set_email
    new_user
    redirect_to root_path, alert: 'Account created! We sended a message to your email to address confirmation.'
  rescue StandardError => e
    redirect_to root_path, alert: e.message.to_s
  end

  private

  def new_user
    password = Devise.friendly_token[0, 20]
    user = User.create!(
      email: email_params[:email],
      password: password,
      password_confirmation: password
    )
    user.authorizations.create(provider: session[:auth]['provider'], uid: session[:auth]['uid'])
  end

  def email_params
    params.require(:user).permit(:email)
  end
end
