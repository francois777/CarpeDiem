class Admin::TariffsController < ApplicationController

  include ApplicationHelper

  before_action :set_tariff, only: [:show, :edit, :update]
  before_action :redirect_unless_signed_in

  def index
    @tariffs = Tariff.all
  end

  def show
    if @tariff.nil?
      flash[:alert] =  t(:tariff_not_found, scope: [:failure]) 
      redirect_to admin_tariffs_path  
    end
  end

  def new
    if params[:tariff]
      @tariff = params[:tariff]
    else
      @tariff = Tariff.new
    end
  end
 
  def create
    puts "Create params: #{params.inspect}"
    @tariff = Tariff.new(tariff_params)
    @tariff.tariff = to_base_amount(params[:tariff][:tariff])
    if @tariff.save
      flash[:notice] = t(:tariff_created, scope: [:success])
      redirect_to [:admin, @tariff]
    else
      flash[:alert] = t(:tariff_create_failed, scope: [:failure])
      render :new
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

    def set_tariff
      @tariff = Tariff.find(params[:id].to_i)
    end

    def tariff_params
      params.require(:tariff).permit(:tariff_category, :tariff, :effective_date, :end_date)
    end

    def redirect_unless_signed_in
      unless signed_in? 
        puts "Visiting ADmin Tariffs - not signed in"
        redirect_to root_path, :status => 302 
      end  
    end

end
