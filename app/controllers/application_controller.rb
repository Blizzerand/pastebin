class ApplicationController < ActionController::Base
  protect_from_forgery

  include PagesHelper
  before_filter :site_navigation

  def site_navigation
  	@navigation_links = { Home: root_path, About: about_path, Help: help_path }
  end

  
end
