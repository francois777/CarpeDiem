class Admin::ReservationRequestsController < ApplicationController

  include ApplicationHelper
  include ReservationRequestsHelper

  before_action :redirect_unless_admin_user
  before_action :set_reservation_request, only: [:show]
  before_action :set_types, only: [:show]

  def index
    @reservation_requests = ReservationRequest.all
  end

  def show
    @unavailable_facilities = list_unavailable_facility_types
  end

  private

    def set_reservation_request
      @reservation_request = ReservationRequest.find(params[:id].to_i)
    end

    def redirect_unless_admin_user
      unless current_user && current_user.admin?
        flash[:alert] = t(:unauthorised_access, scope: [:failure])
        redirect_to root_path
      end
    end

    def set_types
      @facility_types = I18n.t(:facility_types).each_with_index.map { |fType, inx| [fType[1].to_s, inx] }
    end

end