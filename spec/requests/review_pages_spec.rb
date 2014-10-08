# -*- coding: utf-8 -*-
require 'spec_helper'

describe "ReviewPages" do

  before do
    @user = User.create!(name: "foobar", password: "foobar", email: "foobar@example.com", password_confirmation: "foobar")
    @hanzi = Hanzi.create!(character: "大", components: "")
    @pinyindefinition = @hanzi.pinyindefinitions.create!(pinyin: "da4")
    @review = @user.reviews.create!(hanzi: @hanzi, due: Time.now) 
    sign_in @user
    visit review_path(@review)
  end

  subject { page }

  it "should have a progress bar" do
    find('#meter').should have_content('')
  end

  describe "the right hanzi should be an option" do
    it { should have_content(@hanzi.character) }

    describe "and selecting the right option" do
      it "should modify the due time" do
        expect do
          # save_and_open_page
          choose @hanzi.character
          click_button "Submit"
          @review.reload.due
        end.to change(@review, :due)
      end
    end

    describe "and a week-old review" do 
      before do
        Review.record_timestamps = false
        @review.update_attributes :updated_at => 1.week.ago
        @review.save
        Review.record_timestamps = true
        choose @hanzi.character
        click_button "Submit"
        @review.reload.due
      end
      it "should be due in over ten days" do
        expect(@review.due).to be > 10.days.since
      end
    end

  end

    
    
  
end
