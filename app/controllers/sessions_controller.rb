class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && !user.admin?
      flash.alert = t(:only_admin_user_can_sign_in, scope: [:failure])
      redirect_to root_path
      return
    end
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or [:admin, user]
    else
      flash.alert = t(:invalid_email_password, scope: [:failure])
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end  
end