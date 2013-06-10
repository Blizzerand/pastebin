module PagesHelper
def user_name(string)
	if string.blank?
		"Anonymous"
	else
		"#{string}"
	end
end

def current_pages
  	@_current_pages ||= session[:current_page] && Page.find_by_url_hash(session[:current_page]) 
  end


def cookies_handler
	if cookies[:remember_token].nil?

    cookies[:remember_token] = { value: @page.remember_token, expires: 1.hour.from_now.utc }
    
    else
       @page.remember_token= cookies[:remember_token]
       cookies[:remember_token] = { value: @page.remember_token, expires: 1.hour.from_now.utc }
       @page.save
    end
end
  
end

