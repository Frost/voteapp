class Admin::VoteController < ApplicationController
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
    @vote_pages, @votes = paginate :votes, :per_page => 10
  end

  def show
    @vote = Vote.find(params[:id])
  end

  def new
    @vote = Vote.new
  end

  def create
    @vote = Vote.new(params[:vote])
    
    if @vote.save
      flash[:notice] = 'Vote was successfully created.'
      
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @vote = Vote.find(params[:id])
  end

  def update
    @vote = Vote.find(params[:id])
    
    if @vote.update_attributes(params[:vote])
      flash[:notice] = 'Vote was successfully updated.'
      
      redirect_to :action => 'show', :id => @vote
    else
      render :action => 'edit'
    end
  end

  def destroy
    Vote.find(params[:id]).destroy
    
    redirect_to :action => 'list'
  end
end
