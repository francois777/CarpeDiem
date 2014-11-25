class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # include SessionsHelper
  
  before_action :set_locale
   
  def set_locale
    if request.env['HTTP_ACCEPT_LANGUAGE']
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      I18n.locale = extract_locale_from_accept_language_header # unless Rails.env = "test"
      logger.debug "* Locale set to '#{I18n.locale}'"
    end
  end

  private

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
end
