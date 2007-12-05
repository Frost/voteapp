class Admin::RulesController < ApplicationController
  
  layout "admin"
  
  roles_required :root
  
  def index
    @rules = Rule.find(1)
  end
  
  def edit
    @rules = Rule.find(1)
    unless request.get?
      if @rules.update_attributes(params[:rules])
        flash[:notice] = "Rules page updated successfully..."
        redirect_to :action => "index"
      else
        render :action => "edit"
      end
    end
  end
end
