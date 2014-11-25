class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    # puts "SessionsController#create"
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.alert = t(:invalid_email_password, scope: [:failure])
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end  
end