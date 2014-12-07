class Admin::VersionsController < ApplicationController

  def revert
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    link_name = params[:redo] == "true" ? t(:undo, scope: [:actions]) : t(:redo, scope: [:actions])
    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)
    flash[:success] = "#{t(:undid, scope: [:actions])} #{@version.event}. #{link}"
    redirect_to :back
  end  
end
