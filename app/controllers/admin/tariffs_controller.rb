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
    @tariff.price_class = tariff_params[:price_class].to_sym
    if @tariff.valid?
      old_tariffs = Tariff.where('accommodation_type_id = ? AND price_class = ?', @tariff.accommodation_type, Tariff.price_classes[@tariff.price_class])
      unless old_tariffs.nil?
        old_tariffs.each do |old_tariff|
          if old_tariff.end_date.nil?
            old_tariff.end_date = @tariff.effective_date.to_datetime - 1
            old_tariff.save!
          end  
        end
      end
      if @tariff.save
        flash[:success] = "#{t(:tariff_created, scope: [:success])} (#{undo_link})"
        redirect_to [:admin, @accommodation_type, @tariff]
        return
      else
        flash[:alert] = t(:tariff_create_failed, scope: [:failure])
      end  
    else
      flash[:alert] = t(:tariff_create_failed, scope: [:failure])
    end
    render :new      
  end

  def update
    tariff_params[:tariff] = to_base_amount(tariff_params[:tariff])
    updated_params = tariff_params
    updated_params[:tariff] = to_base_amount(tariff_params[:tariff])
    if @tariff.update_attributes(updated_params)
      flash[:success] = "#{t(:tariff_updated, scope: [:success])} (#{undo_link})"
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

  def options(accID)
    { normal_prices: @accTypes[accID]['show_normal_price'], 
      in_season_prices: @accTypes[accID]['show_in_season_price'],
      promotion_prices: @accTypes[accID]['show_promotion']
    }
  end

  private

    def undo_link
      if @tariff.versions.any?
        view_context.link_to(t(:undo, scope: [:actions]), revert_version_path(@tariff.versions.last), method: :post)
      end
    end

    def redo_link
      params[:redo] == "true" ? link = "Undo that plz!" : link = "Redo that plz!"
      view_context.link_to link, undo_path(@tariff.next, redo: !params[:redo]), method: :post
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
      params.require(:tariff).permit(:tariff_category, :price_class, :tariff, :effective_date, :end_date)
    end

    def redirect_unless_signed_in
      redirect_to signin_path unless current_user 
    end

end
