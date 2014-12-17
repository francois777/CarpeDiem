class Admin::ChaletsController < ApplicationController

  include ApplicationHelper

  before_action :set_chalet, only: [:show, :edit, :update, :destroy]
  before_action :redirect_unless_admin_user
  before_action :set_types, only: [:new, :edit]

  def show
    if @chalet.nil?
      flash[:alert] =  t(:chalet_not_found, scope: [:failure]) 
      redirect_to admin_chalets_path  
    end
  end

  def index
    @chalets = Chalet.all
  end

  def new
    if params[:chalet]
      @chalet = params[:chalet]
    else
      @chalet = Chalet.new
    end
  end

  def create
    new_params = chalet_params
    names = I18n.t(:chalet_names).to_a
    new_params[:name] = names[chalet_params[:name].to_i][1]
    new_params[:style_class] = chalet_params[:style_class].to_i
    @chalet = Chalet.new(new_params)
    if @chalet.save
      flash[:success] = "#{t(:chalet_created, scope: [:success])}"
      redirect_to [:admin, @chalet]
    else
      flash[:alert] = t(:chalet_create_failed, scope: [:failure])
      render :new
    end  
  end

  def edit
    unless (current_user && current_user.admin?)
      flash[:alert] = t(:update_not_allowed, scope: [:failure])
      redirect_to root_path
    end
    @chalet_indexes = index_for_names
  end

  def update
    updated_params = chalet_params
    names = I18n.t(:chalet_names).to_a
    updated_params[:name] = names[chalet_params[:name].to_i][1]
    updated_params[:style_class] = chalet_params[:style_class].to_i
    if @chalet.update_attributes(updated_params)
      flash[:success] = "#{t(:chalet_updated, scope: [:success])}"
      redirect_to [:admin, @chalet]
    else
      flash[:alert] = t(:chalet_update_failed, scope: [:failure])
      render :edit
    end  
  end

  private

    def set_chalet
      @chalet = Chalet.find(params[:id].to_i)
    end

    def chalet_params
      params.require(:chalet).permit(:name, :location_code, :style_class, :reservable,
        :inauguration_date, :name_definition)
    end

    def redirect_unless_admin_user
      unless current_user && current_user.admin?
        flash[:alert] = t(:unauthorised_access, scope: [:failure])
        redirect_to root_path
      end
    end

    def set_types
      @style_classes = I18n.t(:style_classes).each_with_index.map { |iType, inx| [iType[1].to_s, inx] }
      @chalet_names = I18n.t(:chalet_names).each_with_index.map { |iType, inx| [iType[1].to_s, inx] }
      @definitions = I18n.t(:tribe_name_definitions).each_with_index.map { |iType, inx| [iType[1].to_s, inx] }
    end

    def index_for_names
      chalets = {}
      clist = I18n.t(:chalet_names)
      clist.each_with_index.map { |nme,inx| chalets[nme[1]] = inx }
      chalets
    end

end
