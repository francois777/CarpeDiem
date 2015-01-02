class Admin::CampingSitesController < ApplicationController

  include ApplicationHelper

  before_action :set_camping_site, only: [:show, :edit, :update, :destroy]
  before_action :redirect_unless_admin_user

  def show
    if @camping_site.nil?
      flash[:alert] =  t(:camping_site_not_found, scope: [:failure]) 
      redirect_to admin_camping_sites_path  
    end
  end

  def index
    @camping_sites = CampingSite.all
  end

  def new
    if params[:camping_site]
      @camping_site = params[:camping_site]
    else
      @camping_site = CampingSite.new
    end
  end

  def create
    new_params = camping_site_params
    @camping_site = CampingSite.new(new_params)
    if @camping_site.save
      flash[:success] = "#{t(:camping_site_created, scope: [:success])}"
      redirect_to [:admin, @camping_site]
    else
      flash[:alert] = t(:camping_site_create_failed, scope: [:failure])
      render :new
    end  
  end

  def edit
    unless (current_user && current_user.admin?)
      flash[:alert] = t(:update_not_allowed, scope: [:failure])
      redirect_to root_path
    end
  end

  def update
    puts "CampingSite params:"
    puts camping_site_params.inspect
    if @camping_site.update_attributes(camping_site_params)
      flash[:success] = "#{t(:camping_site_updated, scope: [:success])}"
      redirect_to [:admin, @camping_site]
    else
      flash[:alert] = t(:camping_site_update_failed, scope: [:failure])
      render :edit
    end  
  end

  private

    def set_camping_site
      @camping_site = CampingSite.find(params[:id].to_i)
    end

    def camping_site_params
      params.require(:camping_site).permit(:location_code, :camping_type, :powered, :reservable)
    end

    def redirect_unless_admin_user
      unless current_user && current_user.admin?
        flash[:alert] = t(:unauthorised_access, scope: [:failure])
        redirect_to root_path
      end
    end

end
