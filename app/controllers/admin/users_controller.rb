class Admin::UsersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user


  def index
    @users = User.all
  end

  def change_password
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t(:new_user_added, scope: [:success])
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t(:profile_updated, scope: [:success])
      redirect_to [:admin, @user]
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, 
                                   :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
