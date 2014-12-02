class Admin::TariffsController < ApplicationController

  before_action :set_tariff, only: [:show, :edit, :update]
  before_action :redirect_unless_signed_in

  def index
  end

  def show
  end

  def new
    @tariff = Tariff.new
  end
 
  def create
  end

  def edit
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
