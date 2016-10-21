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

  describe "visiting a strokeorder link" do
    describe "as not logged in user" do
      before do
        visit hanzi_path(hanzi)
      end
      subject { page }
      it { should_not have_content("add strokeorder") }
    end

    describe "as logged in user" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      before { visit hanzi_path(hanzi) }
      subject { page }
      it { should have_content("add stroke order") }
    end      
  end

end
