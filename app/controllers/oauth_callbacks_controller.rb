# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    connect_thru('GitHub')
  end

  def vkontakte
    connect_thru('Vkontakte')
  end

  private

  def connect_thru(provider)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif auth != :invalid_credential && !auth.nil?
      session[:auth] = auth.except('extra')
      redirect_to recieve_email_path, alert: 'You should enter and confirm your email address'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
