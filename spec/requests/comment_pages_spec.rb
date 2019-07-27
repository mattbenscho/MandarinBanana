# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Comment pages" do

  let(:user) { FactoryBot.create(:user) }
  let(:hanzi) { FactoryBot.create(:hanzi) }
  let(:image) { FactoryBot.create(:image) }
  let(:movie) { FactoryBot.create(:movie) }

  before do
    @subtitle = movie.subtitles.build(sentence: "大王", filename: "dntg-100-200")
    @subtitle.save
    @comment = Comment.new(content: "Lorem Ipsum", user_id: user.id, subtitle_id: @subtitle.id)
    @comment.save
    @hanzicomment = hanzi.comments.build(content: "Lorem Ipsum", user_id: user.id, hanzi_id: hanzi.id)
    @hanzicomment.save
  end

  subject { page }

  describe "comment creation" do

    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
      visit subtitle_path(@subtitle)
    end

    describe "with invalid information" do

      it "should not create a comment" do
        expect { click_button "Comment" }.not_to change(Comment, :count)
      end

      describe "error messages" do
        before { click_button "Comment" }
        it { should have_content('Comment not saved') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'comment_content', with: "Lorem ipsum" }
      it "should create a comment" do
        expect { click_button "Comment" }.to change(Comment, :count).by(1)
      end
    end
  end

  describe "comment deletion for a subtitle comment" do

    before do
      sign_in user
      visit subtitle_path(@subtitle)
    end

    describe "as anonymous visitor" do
      before do
        click_link "Sign out"
        visit subtitle_path(@subtitle)
      end
      it { should_not have_link('delete') }
    end

    describe "as the comment author" do
      it { should have_link('delete') }
      it "should be able to delete another user" do
        expect do
          click_link('delete', match: :first)
        end.to change(Comment, :count).by(-1)
      end
    end

    describe "as another user" do
      let(:other_user) { FactoryBot.create(:user) }
      before do
        sign_in other_user
        visit subtitle_path(@subtitle)
      end

      describe "without delete link" do
        it { should_not have_link('delete') }
      end
    end
  end

  describe "comment deletion for a hanzi comment" do

    before do
      sign_in user
      visit hanzi_path(hanzi)
    end

    describe "as anonymous visitor" do
      before do
        click_link "Sign out"
        visit hanzi_path(hanzi)
      end
      it { should_not have_link('delete') }
    end

    describe "as the comment author" do
      it { should have_link('delete') }
      it "should be able to delete another user" do
        expect do
          click_link('delete', match: :first)
        end.to change(Comment, :count).by(-1)
      end
    end

    describe "as another user" do
      let(:other_user) { FactoryBot.create(:user) }
      before do
        sign_in other_user
        visit hanzi_path(hanzi)
      end

      describe "without delete link" do
        it { should_not have_link('delete') }
      end
    end
  end
end
