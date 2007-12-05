class UserController < ApplicationController
  layout "voteapp"

  roles_required :user, :except => [:create, :login, :logout, :create_voter, :welcome, :show]

  def index
    #    redirect_to :action => "login"
  end

  def create
    if request.get?
      @user = User.new
    else
      # Create the new user
      @user = User.new(params[:user])

      if @user.save
        # Default role as user
        @user.roles << Role.find_by_name("user")

        redirect_to :controller => "user", :action => 'welcome'
      else
        render :action => 'create'
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(session[:user_id])
    
    if request.get?
    else
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        redirect_to :action => 'show', :id => @user
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    roles_required :root
  end

  def login
    if request.get?
      session[:user_id] = nil

      @user = User.new
    else
      # Login the user
      @user = User.new(params[:user])

      if(logged_in_user = @user.login_try)
        session[:user_id] = logged_in_user.id
        
        # Check if user has entered new info
        if not user_is_updated
          flash[:notice] = "We need to know a bit more about you. Please enter the missing information in the form below"
          redirect_to :controller => 'user', :action => 'edit'
          return
        end
        
        if (login_parameters = session[:login_parameters])
          session[:login_parameters] = nil

          redirect_to login_parameters
        else
          redirect_to :controller => 'news', :action => 'list'
        end
      else
        flash[:login_error] = "Login failed. Please try again"
        flash[:notice] = "Invalid login"
        login_parameters = session[:login_parameters]
        session[:login_parameters] = nil

        redirect_to login_parameters
      end
    end
  end

  def logout
    session[:user_id] = nil

    flash[:notice] = "Logged out"

    redirect_to :controller => 'news', :action => 'list'
  end

  def create_voter
    if request.get?
      @user = User.new
      @rating = params[:rating]
      @entry_id = params[:entry_id]
      @referer = params[:referer]
    else
      # Create the new voter
      @user = User.find_by_ticketno_and_status(params[:user][:ticketno], nil)
      logger.debug @user.inspect
      if not @user
        @user = User.new
        @user.ticketno = params[:user][:ticketno]
        @user.password = ""
        if not @user.save
          #flash[:notice] = "Invalid ticket number"
          render
          return
        end
      end

      # Default role as voter
      #@user.roles << Role.find_by_name("voter")

      session[:user_id] = @user.id
  
      @entry = Entry.find(params[:entry_id])
      
      competition = @entry.competition

      if competition.state != CompetitionState.find_by_name("voting")
        flash[:error] = "You cannot vote in a competition that isn't open for voting"
        redirect_to :controller => 'competition', :action => 'show', :id => competition
      else
        @vote = Vote.find_by_entry_id_and_user_id(@entry.id, @user.id)

        if params[:vote_rating] == "0"
          if @vote 
            @vote.destroy
          end
        else
          if not @vote
            @vote = Vote.new
            @vote.entry_id = @entry.id
            @vote.user_id = @user.id
          end
          @vote.rating = params[:rating]
          @vote.save
        end

        if params[:referer] == "competition"
          redirect_to :controller => "competition", :action => "show", :id => Entry.find(@entry.id).competition
        else
          redirect_to :controller => "entry", :action => "show", :id => @entry.id
        end
      end
    end
  end
end