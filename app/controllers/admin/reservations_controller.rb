class Admin::ReservationsController < ApplicationController

  include ApplicationHelper

  before_action :redirect_unless_signed_in
  before_action :set_reservation, only: [:show]

  def show

  end

  private

    def set_reservation
      @reservation = Reservation.find(params[:id].to_i)
    end

    def redirect_unless_signed_in
      redirect_to signin_path unless current_user 
    end

end