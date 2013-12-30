# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Comment pages" do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  let(:movie) { FactoryGirl.create(:movie) }
  before { @subtitle = movie.subtitles.build(sentence: "大王", start: 160, stop: 170) }
  
  before { @user.save }
  before { @subtitle.save }

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "comment creation" do
    before { visit subtitle_path(@subtitle) }

    describe "with invalid information" do

      it "should not create a comment" do
        expect { click_button "Comment" }.not_to change(Comment, :count)
      end

      describe "error messages" do
        before { click_button "Comment" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'comment_content', with: "Lorem ipsum" }
      it "should create a comment" do
        expect { click_button "Comment" }.to change(Comment, :count).by(1)
      end
    end
  end
end
