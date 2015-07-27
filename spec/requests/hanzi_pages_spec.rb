# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Hanzi pages" do

  let(:hanzi) { FactoryGirl.create(:hanzi, character: "大") }

  describe "searching for existing character" do
    before do
      visit root_path
      fill_in "character", with: "大"
      click_button "Go"
    end
    subject { page }
    it { should have_content("大") }
  end

  describe "searching for non-existing character" do
    before do
      visit root_path
      fill_in "character", with: "a"
      click_button "Go"
    end
    subject { page }
    it { should have_content("I didn't find anything") }
  end

end
