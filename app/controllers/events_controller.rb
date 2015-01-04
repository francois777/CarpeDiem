class EventsController < ApplicationController
  include CalendarHelper

  before_action :set_event, only: [:show]

  def index
    puts "EventsController#index"
    @cal_days = []   #= DiaryDay.all
    Event.all.each do |event|
      @cal_days << event.diary_days unless event.diary_days.empty?
    end
    result = {}
    @cal_days.group_by do |calday_group|
      calday_group.each do |calday|
        formatted_dte = calday.day.strftime("%d-%m-%y")
        if result[formatted_dte].nil?
          result[formatted_dte] = [calday]
        else
          result[formatted_dte].push(calday)
        end  
      end
    end
    @grouped_cal_days = result
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