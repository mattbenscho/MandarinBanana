require 'spec_helper'

describe Mnemonic do

  let(:user) { FactoryGirl.create(:user) }
  before { @mnemonic = user.mnemonics.build(aide: "Lorem ipsum", pinyindefinition_id: 23, gorodish_id: nil) }

  subject { @mnemonic }

  its(:user) { should == user }

  it { should be_valid }
  it { should respond_to(:aide) }
  it { should respond_to(:pinyindefinition_id) }
  it { should respond_to(:gorodish_id) }

  describe "it should have a pinyindefinition_id or a gorodish_id" do
    before { @mnemonic.pinyindefinition_id = nil }
    before { @mnemonic.gorodish_id = nil }
    it { should_not be_valid }
  end

  describe "when pinyindefinition_id is not present, it should have a gorodish_id" do
    before { @mnemonic.pinyindefinition_id = nil }
    before { @mnemonic.gorodish_id = 1 }
    it { should be_valid }
  end

  describe "when gorodish_id is not present, it should have a pinyindefinition_id" do
    before { @mnemonic.pinyindefinition_id = 1 }
    before { @mnemonic.gorodish_id = nil }
    it { should be_valid }
  end

  describe "it may not have a gorodish_id and a pinyindefinition_id" do
    before { @mnemonic.pinyindefinition_id = 1 }
    before { @mnemonic.gorodish_id = 1 }
    it { should_not be_valid }
  end

end
