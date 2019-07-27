# -*- coding: utf-8 -*-
require 'spec_helper'

describe "SubtitlePages" do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  let(:movie) { FactoryBot.create(:movie) }
  before { @subtitle = movie.subtitles.build(sentence: "大王", filename: "dntg-100-200") }
  
  before { @user.save }
  before { @subtitle.save }

  subject { page }
  
  before { visit subtitle_path(@subtitle) }

  describe "subtitle page" do
    
    let!(:c1) { FactoryBot.create(:comment, user: @user, subtitle: @subtitle, content: "Foo", hanzi: nil) }
    let!(:c2) { FactoryBot.create(:comment, user: @user, subtitle: @subtitle, content: "Bar", hanzi: nil) }
    
    before { visit subtitle_path(@subtitle) }
    
    it "should have the subtitle sentence as title" do
      expect(page).to have_title(@subtitle.sentence)
    end

    describe "comments" do
      it { should have_content(c1.content) }
      it { should have_content(c2.content) }
      it { should have_content(@subtitle.comments.count) }
    end
  end

  describe "editing" do
    describe "as normal user" do
      it { should_not have_content("edit subtitle") }
    end
    describe "as admin" do
      let(:admin) { FactoryBot.create(:admin) }

      before do
        sign_in admin
        visit subtitle_path(@subtitle)
      end

      it { should have_link("edit subtitle", href: edit_subtitle_path(@subtitle)) }

      describe "editing" do
        before do
          click_link "edit subtitle"
          fill_in "Words", with: "[\"大\"]"
          fill_in "Pinyin", with: "[[\"da4\"]]"
          click_button "Save changes"
        end

        it { should have_content "大" }

      end

    end
  end
end
