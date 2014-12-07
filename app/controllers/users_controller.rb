class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def to_afrikaans
    @settings.language = 'af'
    redirect_to '/'
  end

  def to_english
    @settings.language = 'en'
    redirect_to '/'
  end
end
