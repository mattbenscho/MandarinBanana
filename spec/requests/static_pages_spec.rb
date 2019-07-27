# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Static pages" do

  let!(:fimage) { FactoryBot.create(:featured_image) }

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('MandarinBanana') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

end
