module StaticPagesHelper

	def full_title(page_title)
		base_title = "Sample RoR Pastebin"
		if page_title.blank?
			base_title
		else 
		 	"#{base_title} | #{page_title}"
		end
	end

end
