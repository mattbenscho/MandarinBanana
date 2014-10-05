# -*- coding: utf-8 -*-
require 'spec_helper'

describe Simplified do

  before do
    @simp_hanzi = Hanzi.create!(character: "大", components: "")
    @trad_hanzi = Hanzi.create!(character: "一", components: "")
  end
  let(:simplified) { @trad_hanzi.simplifieds.build(simp_id: @simp_hanzi.id) }

  subject { simplified }

  it { should be_valid }

  describe "relations" do
    it { should respond_to(:simp) }
    it { should respond_to(:trad) }
    its(:simp) { should eq @simp_hanzi }
    its(:trad) { should eq @trad_hanzi }
  end

  describe "when simp id is not present" do
    before { simplified.simp_id = nil }
    it { should_not be_valid }
  end

  describe "when trad id is not present" do
    before { simplified.trad_id = nil }
    it { should_not be_valid }
  end

end
