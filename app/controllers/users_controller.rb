class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def to_afrikaans
    Carpediem::Application.change_locale(:af)
    # Rails.configuration.i18n.default_locale = :af
    # I18n.locale = I18n.default_locale = Rails.configuration.i18n.locale = Rails.configuration.i18n.default_locale
    # puts "Locale is now set to #{I18n.locale}"
    redirect_to '/'
    # render nothing: true
  end
end

module Carpediem
  class Application
    def change_locale(new_locale)
      puts "doing the impossible"
      config.i18n.default_locale = new_locale
      config.i18n.locale = new_locale
    end
  end
end
