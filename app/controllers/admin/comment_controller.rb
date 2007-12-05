class Admin::CommentController < ApplicationController
  roles_required :root
  
  layout "admin"

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def show
    @comment = NewsComment.find(params[:id])
  end

  def new
    @comment = NewsComment.new
  end

  def create
    @comment = NewsComment.new(params[:entry])

    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
      
      redirect_to :controller => 'news', :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = NewsComment.find(params[:id])
  end

  def update
    @comment = NewsComment.find(params[:id])
    
    if @comment.update_attributes(params[:entry])
      flash[:notice] = 'Comment was successfully updated.'
      
      redirect_to :action => 'show', :id => @entry
    else
      render :action => 'edit'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    
    redirect_to :controller => 'news', :action => 'list'
  end
end