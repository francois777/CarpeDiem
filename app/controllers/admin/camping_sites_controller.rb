class Admin::CampingSitesController < ApplicationController

  include ApplicationHelper

  before_action :set_type
  before_action :set_camping_site, only: [:show, :edit, :update, :destroy]
  before_action :redirect_unless_admin_user

  def show
    if @camping_site.nil?
      flash[:alert] =  t(:camping_site_not_found, scope: [:failure]) 
      redirect_to admin_camping_sites_path  
    end
    @cal_day_groups = []
    rented_facilities = @camping_site.rented_facilities
    rented_facilities.each do |rf|
      @cal_day_groups << rf.diary_days
    end
    result = {}

    @cal_day_groups.each do |group|
      group.each do |diary_day|
        formatted_dte = diary_day.day.strftime("%d-%m-%y")
        if result[formatted_dte].nil?
          result[formatted_dte] = [diary_day]
        else
          unless result[formatted_dte].include?(diary_day)
            result[formatted_dte].push(diary_day)
          end  
        end  
      end
    end
    @grouped_cal_days = result
    temp_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @date = Date.new(temp_date.year, temp_date.month, temp_date.day)
  end

  def index
    @camping_sites = type.constantize.all
  end

  def gettents
    puts "Admin::CampingSitesController#gettents"
    @camping_sites = CampingSite.tents
    render :json => @camping_sites
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
      # redirect_to [:admin, @camping_site]
      redirect_to "/admin/camping_sites/#{@camping_site.id}"
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
    # puts "CampingSite#update, params:"
    # puts params.inspect
    type = params['caravan'].any? ? :caravan : :tent
    if @camping_site.update_attributes(camping_site_params(type))
      flash[:success] = "#{t(:camping_site_updated, scope: [:success])}"
      # redirect_to [:admin, @camping_site]
      redirect_to "/admin/camping_sites/#{@camping_site.id}"
    else
      flash[:alert] = t(:camping_site_update_failed, scope: [:failure])
      render :edit
    end  
  end

  private

    def set_type
      @type = type
    end

    def type
      CampingSite.types.include?(params[:type]) ? params[:type] : "CampingSite"
    end

    def set_camping_site
      @camping_site = CampingSite.find(params[:id].to_i)
    end

    def camping_site_params(type = :camping_site)
      params.require(type).permit(:location_code, :type, :powered, :reservable)
    end

    def redirect_unless_admin_user
      unless current_user && current_user.admin?
        flash[:alert] = t(:unauthorised_access, scope: [:failure])
        redirect_to root_path
      end
    end

end
