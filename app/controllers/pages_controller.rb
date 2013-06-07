class PagesController < ApplicationController
  
  def create
  	@page = Page.new(params[:page])
	if @page.save
	  redirect_to page_path(@page.url_hash)
    	else
	  render 'new'  
	end
  end

  def index
  end

  def show
  	@page = Page.find_by_url_hash(params[:id])
  end

  def edit
  end

  def new
  	@page = Page.new
  end



end
