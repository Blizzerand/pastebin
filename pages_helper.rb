def user_name(string)
	if string.blank?
		"Posted by an Anonymous"
	else
		"Posted by #{string}"
	end


def cookies_handler
	if cookies[:remember_token].nil
		@page.remember_token = SecureRandom.urlsafe_base64
		cookies[:remember_token] = { value:   @page.remember_token,
                             expires:1.hour.from_now.utc }
    else
    	@page.remember_token = cookies[:remember_token]
    end
end

end
