# -*- coding: utf-8 -*-
require 'spec_helper'

describe "GorodishPages" do

  let(:gorodish) { FactoryBot.create(:gorodish, element: "ai1") }
  let(:user) { FactoryBot.create(:user) }
  before { @mnemonic = user.mnemonics.build(aide: "Lorem ipsum", pinyindefinition: nil, gorodish: gorodish) }
  before { @mnemonic.save }

  describe "gorodish index" do
    
    before { visit gorodishes_path }

    it "should have an introduction and all gorodishes as headings" do
      expect(page).to have_selector('h2', text: "Introduction")
      expect(page).to have_selector('h2', text: "All Gorodishes")
    end

    it "should have the mnemonic's aide" do
      expect(page).to have_content(@mnemonic.aide)
    end

    describe "edit and delete links for mnemonics should not be displayed for signed out users" do

      before { visit gorodishes_path }

      subject { page }

      it { should have_selector('a', text: 'add mnemonic') }
      it { should have_selector('a', text: 'add a painting') }
      it { should_not have_selector('a', text: 'edit') }
      it { should_not have_selector('a', text: 'delete') }
    end

    describe "display the edit links for signed in users" do
      before { sign_in user }
      before { visit gorodishes_path }

      subject { page }

      it { should have_selector('a', text: 'add mnemonic') }
      it { should have_selector('a', text: 'add a painting') }
      it { should have_selector('a', text: 'edit') }
      it { should have_selector('a', text: 'delete') }

      describe "friendly forwarding back to the gorodishes index" do
        before { click_link "delete" }
        subject { page }
        it { should have_selector('h2', text: "All Gorodishes") }
      end
    end
  end
end
