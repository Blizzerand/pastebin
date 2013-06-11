class PagesController < ApplicationController
  
  def create
  	@page = Page.new(params[:page])
	  
    if @page.save
      cookies_handler    
      redirect_to page_path(@page.url_hash)
      flash[:success] = "New paste Created!"
    else
      render 'new'  
	  end
  end

  def index
    @page = Page.find_all_by_remember_token(cookies[:remember_token]).reverse
    @page_public = Page.last(25).reverse
    @count = Page.find_all_by_remember_token(cookies[:remember_token]).length


  end

  def show
    @current_page_url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  	@page = Page.find_by_url_hash(params[:id])
    @count = Page.find_all_by_remember_token(cookies[:remember_token]).length
  end

  def edit
    @page = Page.find_by_url_hash(params[:id])
    if cookies[:remember_token] != @page.remember_token
       flash[:error] = "This paste doesn't belong to you ;)"
       redirect_to page_path(@page.url_hash)
    end
    
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
       cookies[:remember_token] = { value: @page.remember_token, expires: 1.hour.from_now.utc }
      redirect_to page_path(@page.url_hash)
      flash[:success] = "Your paste has been updated!"
    else
      render 'edit'
    end
  end


  def new
  	@page = Page.new
  end

  def destroy
    @page = Page.find_by_url_hash(params[:id])
    if cookies[:remember_token] == @page.remember_token
      @page.destroy
      flash[:success] = "Page Deleted!"
      redirect_to pages_path
    else
      flash[:error] = "This Page doesn't belong to you! :P"
      redirect_to page_path(@page.url_hash)
    end
  end

end
