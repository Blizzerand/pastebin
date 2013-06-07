require 'spec_helper'

describe "Pages" do
  
  subject { page }

  describe "Pasteit Page" do
  	before { visit pasteit_path }

  	it { should have_selector('title', text: full_title("Paste it!")) }
  	it { should have_selector('h1', text: "Paste it!") }

  end 

  describe "Pasteit" do
  	before { visit pasteit_path }

  	describe "with invalid information" do
  	  it "should not create a page" do
  		expect { click_button "Submit" }.not_to change(Page, :count)
  	  end
      
      describe " should re-render the page " do
        before { click_button "Submit" }

        it { should have_selector('h1', text: 'Paste it!') }
        it { should have_selector('div.alert-alert-error', text: "The form contains") }
    end
  	end

  	describe "with valid information" do
  	  
      before do
  	    fill_in "Name", with: "Manjunath"
  	    fill_in "Title", with: "How to live life"
  	    fill_in "Content", with: "Life is nothing but everything that life is supposed to be!"
  	  end
     
      it "should create a page" do
      	expect { click_button "Submit" }.to change(Page, :count).by(1)
      end

      describe "should redirect to the show" do
        before { click_button "Submit" }

        it { should have_content("Life is nothing but everything that life is supposed to be!") }
        it { should have_content("How to live life") } 
        it { should have_content("Manjunath") }
      end

    end
  end
end
 