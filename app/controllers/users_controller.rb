class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def to_afrikaans
    @settings.language = 'af'
    session[:language] = 'af'
    I18n.locale = 'af'
    redirect_to :back
  end

  def to_english
    @settings.language = 'en'
    session[:language] = 'en'
    I18n.locale = 'en'
    redirect_to :back
  end
end
