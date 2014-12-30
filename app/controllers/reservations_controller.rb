class ReservationsController < ApplicationController

  def request
    puts "ReservationsController#request"
    @reservation = Reservation.new
    # @request = { request: { start_date: Date.today + 1, end_date: Date.today + 2 } }
  end

  private

    def request_params
      params.require(:request).permit(:start_date, :end_date)
    end

end