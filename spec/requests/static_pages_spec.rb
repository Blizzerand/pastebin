require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Home Page" do
    before { visit root_path }

    it { should have_selector('h1', text: "Sample RoR Pastebin App") }
    it { should have_selector('title', text: full_title("")) }
 end


  describe "Help Page" do
    before { visit help_path }

    it { should have_selector('h1', text:"Help Page") }
    it { should have_selector('title', text: full_title("Help")) }
    it { should have_link('Help', href: help_path) }
    it { should have_link('About', href: about_path) }
    it { should have_link('Home', href: root_path) }
  end
    
 
   

  describe "About Page" do
    before { visit about_path }

    it { should have_selector('h1', text: "About Us") }
    it { should have_selector('title', text: full_title("About")) }

  end

end

