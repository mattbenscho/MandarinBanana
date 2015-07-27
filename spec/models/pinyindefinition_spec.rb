# -*- coding: utf-8 -*-
require 'spec_helper'

describe Pinyindefinition do

  let!(:gorodish_d) { FactoryGirl.create(:gorodish, element: "d") }
  let!(:gorodish_a4) { FactoryGirl.create(:gorodish, element: "a4") }
  let(:pinyindefinition) { FactoryGirl.create(:pinyindefinition, gbeginning: "d", gending: "a4") }
  let(:pinyindefinition_xx5) { FactoryGirl.create(:pinyindefinition, gbeginning: "", gending: "") }

  describe "with valid Gorodishes" do
    subject { pinyindefinition }
    it { should be_valid }
    it { should respond_to(:gorodishes) }
    describe "has two gorodishes" do    
      subject { pinyindefinition.gorodishes.count }
      it { is_expected.to eq(2) }
    end
  end

  describe "without Gorodishes" do
    subject { pinyindefinition_xx5 }
    it { should be_valid }
    it { should respond_to(:gorodishes) } 
    describe "has zero Gorodishes" do
      subject { pinyindefinition_xx5.gorodishes.count }
      it { is_expected.to eq(0) }
    end
  end
end
