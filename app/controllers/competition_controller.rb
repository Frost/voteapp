class CompetitionController < ApplicationController
  layout "voteapp"
  
  def index
    list
    render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  def list
    
    competitions = Competition.find(:all, :order => "deadline_on ASC")
    
    @open_competitions = competitions.select {|c| c.state == CompetitionState.find_by_name("open")}
    @pending_competitions = competitions.select {|c| c.state == CompetitionState.find_by_name("pending")}
    @voting_competitions = competitions.select {|c| c.state == CompetitionState.find_by_name("voting")}
    @closed_competitions = competitions.select {|c| c.state == CompetitionState.find_by_name("closed")}
    
  end
  
  def show
    
    
    @competition = Competition.find(params[:id])
    
    @user_entry = @competition.entries.select do |entry|
      entry.user.id == session[:user_id]
    end
    @user_entry = @user_entry[0]
    
    @total_num_entries = @competition.entries.length
    @entries = @competition.entries.select {|c|
      c.state == EntryState.find_by_name("approved")
    }
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = nil
    end
  end
end