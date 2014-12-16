class Admin::EventsController < ApplicationController

  include ApplicationHelper

  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :redirect_unless_admin_user

  def new
    if params[:event]
      @event = params[:event]
    else
      @event = Event.new
    end
  end

  def create
    puts "Params: #{params.inspect}"
    puts "event_params: #{event_params.inspect}"
    new_params = event_params
    puts "new_params: #{new_params.inspect}"
    puts "event_params[:quoted_cost]: #{event_params[:quoted_cost].inspect}"
    quoted_cost = to_base_amount(params[:event][:quoted_cost].to_i)
    puts "quoted_cost: #{quoted_cost.inspect}"

    puts "new_params[:title]: #{new_params[:title]}"
    puts "new_params[:start_date]: #{new_params[:start_date].inspect}"
    puts "new_params[:quoted_cost]: #{new_params[:quoted_cost].inspect}"

    # new_params[:quoted_cost] = event_params[:event][:quoted_cost]
    @event = Event.new(new_params)
    # @event.quoted_cost = to_base_amount(params[:event][:quoted_cost].to_i)
    @event.end_date = @event.start_date if @event.end_date.nil?
    puts "@event errors: #{@event.errors.inspect}"
    if @event.save
      flash[:success] = "#{t(:event_created, scope: [:success])}"
      redirect_to @event
    else
      flash[:alert] = t(:event_create_failed, scope: [:failure])
      render :new
    end  
  end

  def edit
    unless (current_user && current_user.admin?)
      flash[:alert] = t(:update_not_allowed, scope: [:failure])
      redirect_to root_path
    end
  end

  def update
    updated_params = event_params
    updated_params[:quoted_cost] = to_base_amount(event_params[:quoted_cost])
    @event.end_date = @event.start_date if @event.end_date.nil?
    if @event.update_attributes(updated_params)
      flash[:success] = "#{t(:event_updated, scope: [:success])} (#{undo_link})"
      redirect_to @event
    else
      flash[:alert] = t(:event_update_failed, scope: [:failure])
      render :edit
    end  
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

    def redirect_unless_admin_user
      unless current_user && current_user.admin?
        flash[:alert] = t(:unauthorised_access, scope: [:failure])
        redirect_to root_path
      end
    end

end
