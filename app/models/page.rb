# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  title      :string(255)
#  content    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Page < ActiveRecord::Base
  attr_accessible :content, :name, :title

  
  validates :title, presence: true
  validates :content, presence: true

  before_create :create_url_hash

  	private
  		def create_url_hash
  			o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
 			string  =  (0...16).map{ o[rand(o.length)] }.join
 			assign_url_hash(string)
 		end

 		def assign_url_hash(string)

 			if Page.find_by_url_hash(string)
 			create_url_hash 
 			else
 			self.url_hash = string 
 			end
 		end

end
