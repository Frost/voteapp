class Admin::NewsController < ApplicationController
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
    @news_pages, @news = paginate :news, :per_page => 50, :order => "created_at DESC"
  end

  def show
    @news = News.find(params[:id])
  end

  def new
    @news = News.new
  end

  def create
    @news = News.new(params[:news])
    @news.user_id = session[:user_id]
    if @news.save
      flash[:notice] = 'News was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @news = News.find(params[:id])
  end

  def update
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      flash[:notice] = 'News was successfully updated.'
      redirect_to :action => 'show', :id => @news
    else
      render :action => 'edit'
    end
  end

  def destroy
    News.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
