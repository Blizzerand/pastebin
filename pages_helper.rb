def user_name(string)
	if string.blank?
		"Posted by an Anonymous"
	else
		"Posted by #{string}"
	end
end