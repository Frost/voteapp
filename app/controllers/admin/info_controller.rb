class Admin::InfoController < ApplicationController
  
  layout "admin"
  
  roles_required :root
  
  def index
    @info = Info.find(1)
  end
  def edit
    @info = Info.find(1)
    if not request.get?
      if @info.update_attributes(params[:info])
        flash[:notice] = "Info Page Edited successfully!"
        redirect_to :action => 'index'
      else
        render :action => 'edit'
      end
    end
    
  end
end
