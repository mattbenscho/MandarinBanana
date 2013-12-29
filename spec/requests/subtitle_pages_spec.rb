# -*- coding: utf-8 -*-
require 'spec_helper'

describe "SubtitlePages" do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  before do
    @subtitle = Subtitle.new(sentence: "大王", start: 160, stop: 170)
  end
  
  before { @user.save }
  before { @subtitle.save }

  subject { page }
  
  describe "subtitle page" do
    
    let!(:c1) { FactoryGirl.create(:comment, user: @user, subtitle: @subtitle, content: "Foo") }
    let!(:c2) { FactoryGirl.create(:comment, user: @user, subtitle: @subtitle, content: "Bar") }
    
    before { visit subtitle_path(@subtitle) }

    it "should have the subtitle sentence as title" do
      expect(page).to have_title(@subtitle.sentence)
    end
    # it { should have_selector('title', text: @subtitle.sentence) }

    describe "comments" do
      it { should have_content(c1.content) }
      it { should have_content(c2.content) }
      it { should have_content(@subtitle.comments.count) }
    end
  end
end
