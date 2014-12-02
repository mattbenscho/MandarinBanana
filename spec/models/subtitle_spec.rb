# -*- coding: utf-8 -*-
require 'spec_helper'

describe Subtitle do

  let(:movie) { FactoryGirl.create(:movie) }
  before { @subtitle = movie.subtitles.build(sentence: "大王", filename: "dntg-100-200") }

  subject { @subtitle }

  it { should respond_to(:sentence) }
  it { should respond_to(:filename) }
  it { should respond_to(:movie_id) }

  describe "when filename is not present" do
    before { @subtitle.filename = "" }
    it { should_not be_valid }
  end
  
  describe "comment associations" do

    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    end
 
    before { @subtitle = movie.subtitles.build(sentence: "大王", filename: "dntg-100-200") }

    before { @user.save }
    before { @subtitle.save }

    let!(:older_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.day.ago, subtitle: @subtitle, hanzi: nil)
    end

    let!(:newer_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.hour.ago, subtitle: @subtitle, hanzi: nil)
    end

    it "should have the right comments in the right order" do
      @subtitle.comments.should == [older_comment, newer_comment]
    end

    it "should destroy associated comments" do
      comments = @user.comments.to_a
      @user.destroy
      expect(comments).not_to be_empty
      comments.each do |comment|
        expect(Comment.where(id: comment.id)).to be_empty
      end
    end
  end

  describe "movie associations" do
    let(:movie) { FactoryGirl.create(:movie) }
    before { @subtitle = movie.subtitles.build(sentence: "大王", filename: "dntg-100-200") }

    subject { @subtitle }

    it { should respond_to(:movie_id) }
    its(:movie_id) { should == movie.id }

    describe "when movie_id is not present" do
      before { @subtitle.movie_id = nil }
      it { should_not be_valid }
    end
  end
end
