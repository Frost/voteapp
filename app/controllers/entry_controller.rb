class EntryController < ApplicationController
  layout "voteapp"

  roles_required :user, :except => :show
  
  def new
    # Securit audit: You can never enter a second entry
    #                If you are not logged in, you cannot enter.
    #                You have to have the User role to be able to enter
    # id for which competition the entry should be in
    
    if not session[:user_id]
      flash[:error] = "You have to be registred and logged in to enter a competition"
      redirect_to :controller => 'competition', :action => 'show', :id => params[:id]
      return
    end
    
    @user = User.find(session[:user_id])
    
    @competition = Competition.find(params[:id])
    
    if @competition.state == CompetitionState.find_by_name("pending")
      flash[:error] = "This competition is closed for submission."
      redirect_to :controller => 'competition', :action => 'show', :id => params[:id]
      return
    end
    
    if @competition.state == CompetitionState.find_by_name("closed")
      flash[:error] = "This competition is closed."
      redirect_to :controller => 'competition', :action => 'show', :id => params[:id]
      return
    end
    
    prev_entry = Entry.find_by_user_id_and_competition_id(@user.id, @competition.id)
    
    # This will never happen unless a user tries to enter the url manually. Thus
    # an error is appropriate instead of redirecting to edit.
    if prev_entry
      flash[:error] = "You already have a entry in this competition."
      redirect_to :controller => 'competition', :action => 'show', :id => params[:id]
      return
    end
    
    if request.get?
      @entry = Entry.new
    else
      @entry = Entry.new(params[:entry])
      
      @entry.user = User.find(session[:user_id])
      @entry.competition = Competition.find(params[:id])
      @entry.state = EntryState.find_by_name("pending")
      
      if @entry.save
        flash[:notice] = 'Entry was successfully created.'
        redirect_to :controller => 'entry', :action => 'show', :id => @entry
      else
        # could not save the new entry to the database, throw an exception? 
        render
      end
    end
  end

  def edit
    # Security audit: Can only edit owned entry, since it finds by session[:user_id]
    #                 No edit after closed
    # id for which competition the entry should be in
    
    if request.get?
      @entry = Entry.find_by_user_id_and_id(session[:user_id], params[:id])
      @competition = @entry.competition
      
      if not @competition.open?
        flash[:error] = 'This competition is not open.'
        redirect_to :action => 'show', :id => @entry
        return
      end
      
    else
      @entry = Entry.find_by_user_id_and_id(session[:user_id], params[:id])
      
      @competition = @entry.competition
      
      if not @competition.open?
        flash[:error] = 'This competition is not open.'
        redirect_to :action => 'show', :id => @entry
        return
      end
      
      if @entry.update_attributes(params[:entry])
        flash[:notice] = 'Entry was successfully updated.'
      
        redirect_to :controller => 'entry', :action => 'show', :id => @entry
      else
        # could not update the entry to the database, throw an exception? 
        
        render
      end
    end
  end
  
  def show
    # Security audit: You can never show an entry before deadline OR if you own the entry
    # check the time so we dont displays entries to other users before deadline (!)
    @entry = Entry.find(params[:id])
    
    if session[:user_id]
      @user = User.find(session[:user_id])
      @vote = Vote.find_by_entry_id_and_user_id(@entry.id, @user.id)
    end
    
    if @entry.competition.reached_deadline? or (session[:user_id] and @entry.user == User.find(session[:user_id]))
      # Antingen har tävlingen nått deadline eller så är det inloggad användares bidrag
      render
    else
      # Here be 403.
      render :inline => 'Access to this entry is denied', :layout => true
    end
  end
  
  private  
end
