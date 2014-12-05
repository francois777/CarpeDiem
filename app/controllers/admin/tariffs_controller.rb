class Admin::TariffsController < ApplicationController

  include ApplicationHelper

  before_action :get_accom_type
  before_action :set_tariff, only: [:show, :edit, :update]
  before_action :redirect_unless_signed_in

  def index
    @tariffs = @accommodation_type.tariffs
  end

  def show
    if @tariff.nil?
      flash[:alert] =  t(:tariff_not_found, scope: [:failure]) 
      redirect_to admin_tariffs_path  
    end
  end

  def summary
    promotions = AccommodationType.promotions
    if promotions.any?
      @promotion_header = header_line(:promotion)
      @promotion_dtl_lines = tariff_details(:promotion)
    end  
    @no_power_header = header_line(:without_power_points)
    @no_power_dtl_lines = []
    @power_header = header_line(:powered_tariff)
    @power_dtl_lines = []
    @day_visitor_header = header_line(:day_visitor)
    @day_visitor_dtl_lines = []
    @chalet_header = header_line(:chalet_tariff)
    @chalet_dtl_lines = []
    @groups_header = header_line(:group_tariff)
    @groups_dtl_lines = []
  end

  def new
    if params[:tariff]
      @tariff = params[:tariff]
    else
      @tariff = Tariff.new
    end
  end
 
  def create
    @tariff = @accommodation_type.tariffs.new(tariff_params)
    @tariff.tariff = to_base_amount(params[:tariff][:tariff])
    if @tariff.save
      flash[:notice] = t(:tariff_created, scope: [:success])
      redirect_to [:admin, @accommodation_type, @tariff]
    else
      flash[:alert] = t(:tariff_create_failed, scope: [:failure])
      render :new
    end  
  end

  def update
    if @tariff.update_attributes(tariff_params)
      flash[:success] = t(:tariff_updated, scope: [:success])
      redirect_to [:admin, @accommodation_type, @tariff]
    else
      flash[:alert] = t(:tariff_update_failed, scope: [:failure])
      render :edit
    end  
  end

  def edit
    unless (current_user && current_user.admin?)
      flash[:alert] = t(:update_not_allowed, scope: [:failure])
      redirect_to root_path
    end
  end

  def destroy
  end

  private

    def header_line(accommodation_type)
      case accommodation_type
      when :promotion
        [ "", "", "", ""] 
      when :without_power_points
        [ t(:without_power_points, scope: [:accommodation]).upcase,
          t(:per_site, scope: [:accommodation]).upcase,
          t(:per_person_per_night, scope: [:accommodation]).upcase,
          ""
        ]
      when :powered_tariff
        [ t(:with_power_points, scope: [:accommodation]).upcase,
          t(:per_site, scope: [:accommodation]).upcase,
          t(:per_person_per_night, scope: [:accommodation]).upcase,
          ""
        ]
      when :day_visitor
        [ "", "", t(:per_person, scope: [:accommodation]).upcase, ""]
      when :chalet_tariff
        [ t(:with_power_points, scope: [:accommodation]).upcase,
          "",
          t(:per_night_for_chalet, scope: [:accommodation]).upcase,
          ""
        ]
      when :group_tariff
        [ t(:without_power_points, scope: [:accommodation]).upcase,
          "",
          t(:per_person, scope: [:accommodation]).upcase,
          t(:tents_and_caravans, scope: [:accommodation]).upcase
        ]
      else
       [ "", "", "", ""]  
      end
    end

    def tariff_details(accommodation_type)
      case accommodation_type
      when :promotion
        if AccommodationType.where(show: true)
          [ "", "", "", ""]  
        else
          [ "", "", "", ""]
        end    
      end  
    end

    def get_accom_type
      if params[:accommodation_type_id].nil? || params[:accommodation_type_id].empty?
        flash[:alert] = "Accommodation type missing"
        redirect_to admin_accommodation_types_path
      end
      @accommodation_type = AccommodationType.find(params[:accommodation_type_id])
    end

    def set_tariff
      @tariff = Tariff.find(params[:id].to_i)
    end

    def tariff_params
      params.require(:tariff).permit(:tariff_category, :tariff, :effective_date, :end_date)
    end

    def redirect_unless_signed_in
      unless signed_in? 
        redirect_to root_path, :status => 302 
      end  
    end

end
