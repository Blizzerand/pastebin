module PagesHelper
def user_name(string)
	if string.blank?
		"Anonymous"
	else
		"#{string}"
	end
end
end

