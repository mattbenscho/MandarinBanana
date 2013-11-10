require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Mandarin Banana'" do
      visit '/static_pages/home'
      expect(page).to have_content('Mandarin Banana')
    end

    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title("Mandarin Banana")
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_title("Mandarin Banana | Help")
    end
  end

  describe "About page" do

    it "should have the content 'About Mandarin Banana'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Mandarin Banana')
    end

    it "should have the title 'About Mandarin Banana'" do
      visit '/static_pages/about'
      expect(page).to have_title("Mandarin Banana | About Mandarin Banana")
    end
  end
end
