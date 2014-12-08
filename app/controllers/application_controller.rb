class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :define_settings, :set_locale
   
  def set_locale
    if request.env['HTTP_ACCEPT_LANGUAGE']
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      # I18n.locale = extract_locale_from_accept_language_header # unless Rails.env = "test"
      puts "\n\n"
      puts "Current language setting is #{session[:language]}"
      unless (session[:language] == 'en' || session[:language] == 'af')
        session[:language] = 'en'
        @settings.language = 'en'
      end
      if session[:language]
        puts "session[:language] = #{session[:language]}"
        @settings.language = session[:language]
      else
        @settings.language = request.env['HTTP_ACCEPT_LANGUAGE']
        puts "settings.language = #{settings.language}"
        session[:language] = @settings.language
      end
      puts "\n\n"
      I18n.locale = @settings.language
      logger.debug "* Locale set to '#{I18n.locale}'"
    end
  end

  def define_settings
    @settings ||= AppConfig.instance
  end

  private

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
end
