class EventsController < ApplicationController
  include CalendarHelper

  before_action :set_event, only: [:show]

  def index
    puts "EventsController#index"
    @events = Event.all
    # @events_by_start_date = @events.group_by(&:start_date)

    result = {}
    @events.group_by do |event|
      stdate = event.start_date.strftime("%d-%m-%y")
      if result[stdate].nil?
        result[stdate] = [event]
      else
        result[stdate].push(event)
      end  
    end
    @events_by_start_date = result
    temp_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @date = Date.new(temp_date.year, temp_date.month, temp_date.day)
  end

  def show
    if @event.nil?
      flash[:alert] =  t(:event_not_found, scope: [:failure]) 
      redirect_to events_path  
    end
  end

  private

    def set_event
      @event = Event.find(params[:id].to_i)
    end

end