# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :jumpto_setup

  # define the PERMISSIONS hash for controller default permissions
  unless const_defined?(:PERMISSIONS)
    PERMISSIONS = Hash.new
  end
  
  # default permissions for a controllers all actions
  def self.roles_required(permissions, params = nil)
    PERMISSIONS[self] = Hash.new
    PERMISSIONS[self]['default'] = permissions
    
    if params == nil
      before_filter (:roles_required)
    else
      if params[:except]
        before_filter :roles_required, :except => params[:except]
      elsif params[:only]
        before_filter :roles_required, :except => params[:only]
      end
    end
  end
  
  # redirect if he dosnt have correct permissions
  def roles_required(permissions = [])
    
    # redirect if the user isnt logged in
    if session[:user_id] == nil
      flash[:notice] = "Please log in"
      
      session[:login_parameters] = request.parameters

      redirect_to :controller => 'user', :action => 'login'
      
      return false
    end
    
    if permissions != []
      required_permissions = permissions
    else ApplicationController::PERMISSIONS[self.class]
      required_permissions = ApplicationController::PERMISSIONS[self.class]['default']
    end
    
    return true if user_permitted?([required_permissions])
    
    redirect_to_index :controller => "/competition", 
                      :message => "You dont have access to view that page"
  end
  
  # does the user meet the needed permissions
  def user_permitted?(permissions)
    
    if permissions.is_a? String or permissions.is_a? Symbol
      permissions = [permissions]
    end
    
    required_permissions = []
    
    permissions.each { |p| required_permissions << Role.find_by_name(p.to_s) }
    
    user_roles = User.find(session[:user_id]).roles

    # check that the user has at least one of the requested roles
    required_permissions.each { |role| return true if user_roles.include?(role) }
    return false
  end

  private
  def jumpto_setup
    unless (controller_name == "user" and action_name) or
        (controller_name == "entry")
      session[:jumpto] = request.parameters
      session[:login_parameters] = request.parameters
    end
  end
  
  def user_is_updated
    #if not session[:user_id]
    #  return
    #end
    
    user = User.find(session[:user_id])
    
    logger.info "user status = #{user.status.nil?}"
    
    if user.status.nil?
      return false
    else
      return true
    end
  end
  
  def login_required
    if session[:user_id] == nil
      flash[:notice] = "Please log in"
      
      session[:login_parameters] = request.parameters

      redirect_to :controller => "/user", :action => "login"
    end
  end
  
  def redirect_to_index (params)
    flash[:notice] = params[:message] if params[:message]
    
    if params[:controller] == nil
      redirect_to :action => "index"
    else
      redirect_to :controller => params[:controller], :action => "index"
    end
  end
end