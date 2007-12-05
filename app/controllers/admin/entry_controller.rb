class Admin::EntryController < ApplicationController
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
    # TODO: sortera entries efter state, och gruppera dem efter compo
    @entry_pages, @entries = paginate :entries, :per_page => 1000, :order => "competition_id ASC"
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
    @users = User.find(:all)
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(params[:entry])

    if @entry.save
      flash[:notice] = 'Entry was successfully created.'
      
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    
    if @entry.update_attributes(params[:entry])
      flash[:notice] = 'Entry was successfully updated.'
      
      redirect_to :action => 'show', :id => @entry
    else
      render :action => 'edit'
    end
  end

  def destroy
    Entry.find(params[:id]).destroy
    
    redirect_to :action => 'list'
  end
end
