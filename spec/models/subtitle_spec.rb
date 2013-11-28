require 'spec_helper'

describe Subtitle do

  before do
    @subtitle = Subtitle.new(sentence: "Dies ist ein Untertitel", start: 1, stop: 10)
  end

  subject { @subtitle }

  it { should respond_to(:sentence) }
  it { should respond_to(:start) }
  it { should respond_to(:stop) }

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

end
