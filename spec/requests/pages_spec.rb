require 'spec_helper'

describe "Pages" do
  
  subject { page }

  describe "Pasteit" do
  	before { visit pasteit_path }

  	it { should have_selector('title', text: full_title("Pasteit!")) }
  	it { should have_selector('h1', text: "Pasteit!") }
  end 
end
 