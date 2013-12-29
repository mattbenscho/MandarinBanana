# -*- coding: utf-8 -*-
require 'spec_helper'

describe Comment do

  let(:user) { FactoryGirl.create(:user) }
  before { @comment = user.comments.build(content: "Lorem ipsum", subtitle_id: 23) }

  subject { @comment }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:subtitle_id) }
  it { should respond_to(:user) }

  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @comment.user_id = nil }
    it { should_not be_valid}
  end

  describe "when subtitle_id is not present" do
    before { @comment.subtitle_id = nil }
    it { should_not be_valid}
  end

  describe "with blank content" do
    before { @comment.content = " " }
    it { should_not be_valid }
  end

end
