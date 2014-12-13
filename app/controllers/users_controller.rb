class UsersController < ApplicationController
  before_filter :signed_in_user, :only => [:account_settings, :set_account_info]

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

# ======== Handles Account Settings ========  

  def account_settings
    @user = current_user
  end

  def set_account_info
    old_user = current_user
    @user = old_user.authenticate(user_params[:password])
    # verify
    if !@user || @user.nil?
      @user = old_user
      @user.errors[:password] = t(:password_is_incorrect, scope: [:failure])
      flash[:alert] = t(:password_is_incorrect, scope: [:failure])
      render :action => "account_settings"
      return
    end  

    unless account_settings_changed?(old_user)
      flash[:notice] = t(:nothing_changed, scope: [:info])
      render :action => "account_settings" 
      return
    end  
    # Something changed

    unless new_passwords_valid?
      flash[:alert] = "New passwords contain errors"
      render :action => "account_settings"
      return
    end      

    @user.update(user_params.except(:new_password, :new_password_confirmation))
    if @user.valid?
      @user.save!
      flash[:success] = t(:account_settings_have_changed, scope: [:success])
      redirect_to [:admin, @user]
      return
    end  

    flash[:alert] = t(:an_error_occurred, scope: [:error])
    render :action => "account_settings"
  end

# ======== Handles Password Reset ========

  def forgot_password
    @user = User.new
  end

  # equivalent of send_password_reset_instructions
  def allocate_password
    email = params[:user][:email]
    user = User.find_by_email(email)
    if user
      puts "Will assign new password"
      token = SecureRandom.urlsafe_base64
      user.password_reset_token = token
      user.password = token
      user.password_expires_after = 24.hours.from_now
      user.save!

      test_user = User.where('password_reset_token = ?', user.password_reset_token)
      test_user = test_user.first if test_user
      password_reset_url = 'http://localhost:3000/password_reset?' + user.password_reset_token

      # Disable temporalily until pony is in place
      # UserMailer.reset_password_email(user).deliver
      flash[:notice] = "Please follow the instructions explained to you, #{password_reset_url}"
      # flash[:notice] = 'Password instructions have been mailed to you.  Please check your inbox.'
      redirect_to :signin
    else
      @user = User.new
      # put the previous value back.
      @user.email = params[:user][:email]
      flash[:alert] = t(:user_not_registered, scope: [:errors], email: @user.email)
      render :action => "forgot_password"
    end    
  end

  # The user has landed on the password reset page, they need to enter a new password.
  # HTTP get
  def password_reset
    puts "UsersController#password_reset, params = "
    puts params.inspect
    token = params.first[0]
    @user = User.find_by_password_reset_token(token)
    @user = User.first

    if @user.nil?
      flash[:error] = t(:you_have_not_requested_pw_reset, scope: [:errors])
      redirect_to :root
      return
    end

    if @user.password_expires_after < DateTime.now
      clear_password_reset(@user)
      @user.save
      flash[:error] = t(:password_expired_request_reset, scope: [:errors])
      redirect_to :forgot_password
    end
  end  

  # The user has entered a new password. Need to verify and save.
  # HTTP put
  def new_password
    email = params[:user][:email]
    @user = User.find_by_email(email)
    puts "new_password: user_params: #{user_params.inspect}"

    if verify_new_password(user_params)
      new_params = {}
      new_params[:password] = user_params[:new_password]
      @user.update(new_params)
      # @user.password = @user.new_password

      if @user.valid?
        clear_password_reset(@user)
        flash[:notice] = t(:requested_pw_reset_enter_pw, scope: [:info])
        redirect_to :signin
      else
        render :action => "password_reset"
      end
    else
      @user.errors[:new_password] = t(:not_blank_and_match_pw_verification, scope: [:errors])
      render :action => "password_reset"
    end
  end  

  private

    def new_passwords_valid?
      return true if user_params[:new_password].empty? && user_params[:new_password_confirmation].empty?
      if user_params[:new_password].present? || user_params[:new_password_confirmation].present?
        return true if user_params[:new_password] == user_params[:new_password_confirmation]
      end  
      @user.errors[:new_password] = t(:new_password_required, scope: [:errors])
      @user.errors[:new_password_confirmation] = t(:confirmation_required_same_as_new_pw, scope: [:errors])
      false
    end

    def account_settings_changed?(old_user)
      return true unless old_user.first_name == user_params[:first_name]
      return true unless old_user.last_name == user_params[:last_name]
      return true unless old_user.email == user_params[:email]
      return true if user_params[:new_password].present?
      user_params[:new_password_confirmation].present?
    end

    def user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :new_password, :new_password_confirmation)
    end

    def clear_password_reset(user)
      user.password_expires_after = nil
      user.password_reset_token = nil
      user.save!
    end

    def verify_new_password(passwords)
      result = true
      if passwords[:new_password].blank?
        puts "New password is blank"
      else
        puts "New password is not blank"
      end
      if passwords[:new_password_confirmation].blank?
        puts "New password confirmation is blank"
      else
        puts "New password confirmation is not blank"
      end

      if passwords[:new_password].blank? || (passwords[:new_password] != passwords[:new_password_confirmation])
        result = false
      end

      result
    end
end
