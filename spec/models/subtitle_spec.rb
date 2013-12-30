# -*- coding: utf-8 -*-
require 'spec_helper'

describe Subtitle do

  let(:movie) { FactoryGirl.create(:movie) }
  before { @subtitle = movie.subtitles.build(sentence: "大王", start: 160, stop: 170) }

  subject { @subtitle }

  it { should respond_to(:sentence) }
  it { should respond_to(:start) }
  it { should respond_to(:stop) }
  it { should respond_to(:movie_id) }

  describe "when sentence is not present" do
    before { @subtitle.sentence = " " }
    it { should_not be_valid }
  end
  
  describe "when start is not present" do
    before { @subtitle.start = "" }
    it { should_not be_valid }
  end
  
  describe "when stop is not present" do
    before { @subtitle.stop = "" }
    it { should_not be_valid }
  end
  
  describe "with stop smaller than start" do
    before do
      @subtitle.start = 160
      @subtitle.stop = 150
    end
    it { should_not be_valid }
  end
  
  describe "with stop equal to start" do
    before do
      @subtitle.start = 160
      @subtitle.stop = 160
    end
    it { should_not be_valid }
  end
  
  describe "with start lower than zero" do
    before { @subtitle.start = -1 }
    it { should_not be_valid }
  end

  describe "with blank sentence" do
    before { @subtitle.sentence = " " }
    it { should_not be_valid }
  end

  describe "comment associations" do

    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    end
 
    before do
      @subtitle = Subtitle.new(sentence: "大王", start: 160, stop: 170, movie_id: 1)
    end

    before { @user.save }
    before { @subtitle.save }

    let!(:older_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.day.ago, subtitle: @subtitle)
    end

    let!(:newer_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.hour.ago, subtitle: @subtitle)
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
    before { @subtitle = movie.subtitles.build(sentence: "大王", start: 160, stop: 170) }

    subject { @subtitle }

    it { should respond_to(:movie_id) }
    its(:movie_id) { should == movie.id }

    describe "when movie_id is not present" do
      before { @subtitle.movie_id = nil }
      it { should_not be_valid }
    end
  end
end
