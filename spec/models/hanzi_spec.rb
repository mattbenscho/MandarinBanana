# -*- coding: utf-8 -*-
require 'spec_helper'

describe Hanzi do

  it { should respond_to(:simplifieds) }
  it { should respond_to(:simplified_variants) }
  it { should respond_to(:traditionals) }
  it { should respond_to(:traditional_variants) }
  it { should respond_to(:simplified_by?) }
  it { should respond_to(:simplify_by!) }

  describe "simplification" do
    before do
      @hanzi = Hanzi.create!(character: "大", components: "")
      @other_hanzi = Hanzi.create!(character: "一", components: "")
      @hanzi.simplify_by!(@other_hanzi)
    end

    subject { @hanzi }

    it { should be_simplified_by(@other_hanzi) }
    its(:simplified_variants) { should include(@other_hanzi) }

    describe "other hanzi" do
      subject { @other_hanzi }
      its(:traditional_variants) { should include(@hanzi) }
    end

  end
      
end
