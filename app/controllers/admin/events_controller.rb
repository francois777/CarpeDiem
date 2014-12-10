class Admin::EventsController < ApplicationController

  include ApplicationHelper

  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :redirect_unless_signed_in

  def new
    if params[:event]
      @event = params[:event]
    else
      @event = Event.new
    end
  end

  def create
    @event = Event.new(event_params)
    @event.quoted_cost = to_base_amount(params[:event][:quoted_cost])
    if @event.save
      flash[:success] = "#{t(:event_created, scope: [:success])}"
      redirect_to @event
    else
      flash[:alert] = t(:event_create_failed, scope: [:failure])
      render :new
    end  
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def set_event
      @event = Event.find(params[:id].to_i)
    end

    def event_params
      params.require(:event).permit(:title, :organiser_name, :organiser_telephone, :start_date,
        :end_date, :confirmed, :estimated_guests_count, :estimated_chalets_required,
        :estimated_sites_required, :power_required, :meals_required, :quoted_cost, :comments)
    end

    def undo_link
      if @event.versions.any?
        view_context.link_to(t(:undo, scope: [:actions]), revert_version_path(@event.versions.last), method: :post)
      end
    end

    def redo_link
      params[:redo] == "true" ? link = "Undo that plz!" : link = "Redo that plz!"
      view_context.link_to link, undo_path(@event.next, redo: !params[:redo]), method: :post
    end

    def redirect_unless_signed_in
      redirect_to root_path unless current_user
    end

end
