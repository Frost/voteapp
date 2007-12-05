class VoteController < ApplicationController
  # Man får inte rösta om
  # .. man inte är inloggad
  # .. tävlingen är stängd
  def cast
    @referer = params[:referer]
    
    if session[:user_id]
      @user = User.find(session[:user_id])
      @user = nil unless @user.roles.include?(Role.find_by_name("voter"))
    else
      @user = nil
    end
    
    # var de fulla eller?
    
    #   #if @user.roles.include? Role.find_by_name("voter")
    #   if @user.roles.index(Role.find_by_name("voter")) == nil
    #     @user = nil
    #   end
    # else
    #   @user = nil
    # end

    @entry = Entry.find(params[:entry_id])

    competition = @entry.competition

    unless competition.state == CompetitionState.find_by_name("voting")
      flash[:error] = "You cannot vote in a competition that isn't open for voting"
      redirect_to :controller => 'competition', :action => 'show', :id => competition
      return
    else

      if @user == nil
        redirect_to :controller => "user", :action => "create_voter", :entry_id => @entry.id, :rating => params[:rating], :referer => @referer
      else
        @vote = Vote.find_by_entry_id_and_user_id(@entry.id, @user.id)

        if params[:rating] == "0"
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

        if @referer == "competition"
          redirect_to :controller => "competition", :action => "show", :id => @entry.competition
        else
          redirect_to :controller => "entry", :action => "show", :id => @entry.id
        end
      end
    end

  end

end
