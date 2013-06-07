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

require 'spec_helper'

describe Page do
  before { @page = Page.new(name:"Chris", title:" Lorem Ipsum", content: "Lorem Ipsum is a language which is based on Italian") }

  subject { @page }

  it { should respond_to(:name) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }

  it { should be_valid }

  describe "when name is not present" do
  	before { @page.name='' }

  	it { should_not be_valid }
  end

  describe "when title is not present" do
  	before { @page.title='' }

  	it { should_not be_valid }
  end
  
  describe "when content is not present" do
  	before { @page.content='' }

  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @page.name = 'a'*51 }

  	it { should_not be_valid }
  end

  describe "when name is too short" do
  	before { @page.name = 'ak' }

  	it { should_not be_valid }
  end
end
