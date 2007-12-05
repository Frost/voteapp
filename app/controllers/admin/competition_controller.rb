class Admin::CompetitionController < ApplicationController
  roles_required :root
  
  layout "admin"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @competition_pages, @competitions = paginate :competitions, 
                                                  :per_page => 50, 
                                                  :order => "deadline_on ASC"
  end

  def show
    # CHANGED: admin/compo/show listar numera entries efter compostate tills deadline har passerat, varpå den börjar lista entries efter flest antal röster istället
    @competition = Competition.find(params[:id], :include => :entries)
    if @competition.reached_deadline?
      @entries = @competition.entries.sort_by {|e| e.valid_votes }.reverse
    else
      @entries = @competition.entries.sort_by {|e| e.state.name }
    end
  end

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new(params[:competition])
    
    if @competition.save
      flash[:notice] = 'Competition was successfully created.'
      
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:id])
    
    if @competition.update_attributes(params[:competition])
      flash[:notice] = 'Competition was successfully updated.'
      
      redirect_to :action => 'show', :id => @competition
    else
      render :action => 'edit'
    end
  end

  def destroy
    Competition.find(params[:id]).destroy
    
    redirect_to :action => 'list'
  end
end
