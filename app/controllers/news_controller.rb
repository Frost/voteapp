class NewsController < ApplicationController
  
  roles_required :user, :except => ['list','show','index']
  
  layout "voteapp"

  def index
    list
    render :action => 'list'
  end
  def list
#    @news, @news_pages = paginate :news, :per_page => 10
    @news = News.find(:all).reverse
  end
  def show
    @news = News.find(params[:id])
  end
  
  def comment
    @comment = NewsComment.new(params[:news_comment])
    @comment.user_id = session[:user_id]
    @comment.news_id = params[:id]
    if @comment.save
      flash[:notice] = 'comment saved'
    else
      flash[:notice] = 'comment was not saved'
    end
    redirect_to :action => 'show', :id => params[:id]
  end
end
