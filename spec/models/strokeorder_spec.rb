# -*- coding: utf-8 -*-
require 'spec_helper'

describe Strokeorder do
  
  before do
    @user = FactoryBot.create(:user)
    @hanzi = FactoryBot.create(:hanzi)
    @strokeorder = Strokeorder.new(user_id: @user.id,
                                   hanzi_id: @hanzi.id,
                                   strokes: "[[0, 10], [1, 11], [5, -7]]")
  end

  subject { @strokeorder }

  it { should respond_to(:user_id) }
  it { should respond_to(:hanzi_id) }
  it { should respond_to(:strokes) }
  
  describe "when user_id is not present" do
    before { @strokeorder.user_id = nil }
    it { should_not be_valid }
  end

  describe "when hanzi_id is not present" do
    before { @strokeorder.hanzi_id = nil }
    it { should_not be_valid }
  end

  describe "when there are no x,y values" do
    before { @strokeorder.strokes = nil }
    it { should_not be_valid }
  end

end
