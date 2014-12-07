class Admin::TariffsController < ApplicationController

  include ApplicationHelper

  before_action :get_accom_type, except: [:summary]
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
    # @test = site_tariffs_without_power(@accommodation_type.tariffs.no_power.first)
  end


  def options(accID)
    { normal_prices: @accTypes[accID]['show_normal_price'], 
      in_season_prices: @accTypes[accID]['show_in_season_price'],
      promotion_prices: @accTypes[accID]['show_promotion']
    }
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
