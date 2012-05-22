require 'spec_helper'

describe "Static pages" do

  subject { page } 
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }  
  end
  
  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }
    
    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
    
    it_should_behave_like "all static pages"
  end
  
  it "should have the right links on the footer" do
    visit contact_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
  end
  
  describe "should have the right links on the header" do
    describe "when not signed in" do
      before { visit root_path }
      it { should_not have_link("Transactions")}
      it { should_not have_link("Categories") }
      it { should_not have_link("Sign out") }
      it { should_not have_content("Signed in as") }
    end
    
    describe "when signed in" do
      let(:user) { FactoryGirl.create(:user, active: true) }
      before do 
        sign_in user 
      end
      it { should have_link("Transactions") }
      it { should have_link("Categories") }
      it { should have_link("Reports") }
      it { should have_link("Sign out") }
      it { should have_content("Signed in as #{user.email}") }
      it { should_not have_link("Sign in") }
      it { should_not have_link("Sign up") }
      
      it "should navigate to the correct page when header links are clicked" do
        visit root_path
        click_link "Transactions"
        page.should have_selector("title", text: full_title("Transactions"))
        click_link "Categories"
        page.should have_selector("title", text: full_title("Categories"))
        click_link "Reports"
        page.should have_selector("title", text: full_title("Reports"))
      end
    end
  end
end
