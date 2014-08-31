# -*- coding: utf-8 -*-
require 'spec_helper'

describe "GorodishPages" do

  let(:gorodish) { FactoryGirl.create(:gorodish) }

  subject { page }
  
  describe "gorodish index" do
    
    before { visit gorodishes_path }

    it "should have an introduction and all gorodishes as headings" do
      expect(page).to have_selector('h1', text: "Introduction")
      expect(page).to have_selector('h1', text: "All Gorodishes")
    end

  end
end
