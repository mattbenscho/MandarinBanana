# -*- coding: utf-8 -*-
require 'spec_helper'

describe "MnemonicsPages" do
  before do
    @user = User.create!(name: "foobar", password: "foobar", email: "foobar@example.com", password_confirmation: "foobar")
    @hanzi = Hanzi.create!(character: "大", components: "")
    @pinyindefinition = @hanzi.pinyindefinitions.create!(pinyin: "da4", definition: "bla")
    sign_in @user
    visit hanzi_path(@hanzi)
  end

  subject { page }

  describe "hanzi and link" do
    it { should have_content(@hanzi.character) }
    it { should have_link('add a mnemonic for this meaning of ' + @hanzi.character,
                          href: "/pinyindefinitions/" + @pinyindefinition.id.to_s + "/mnemonics/new") }
    
    describe "new mnemonic form" do
      before { click_link('add a mnemonic for this meaning of ' + @hanzi.character, match: :first) }
      it { should have_content('Invent a new mnemonic for ' + @hanzi.character) }

      before { fill_in "mnemonic_aide", with: "New mnemonic content" }
      it "should create a new mnemonic" do
        expect do
          click_button('Submit', match: :first)
        end.to change(Mnemonic, :count).by(1)
      end

      describe "we should be redirected to the hanzi and the new mnemonic should be shown" do
        it { should have_content(@hanzi.character) }
        it { should have_content("New mnemonic content") }
      end
    end

    describe "edit mnemonic link" do
      before do
        @mnemonic = @user.mnemonics.create!(aide: "Bla", pinyindefinition: @pinyindefinition)
        visit hanzi_path(@mnemonic.pinyindefinition.hanzi)
      end
      it { should have_link('edit', href: edit_mnemonic_path(@mnemonic)) }

      describe "edit form" do
        before { visit edit_mnemonic_path(@mnemonic) }
        it { should have_content("Edit your mnemonic for " + @hanzi.character) }
        it { should have_content(@pinyindefinition.pinyin) }
        it { should have_content(@pinyindefinition.definition) }
      end
    end


  end

end
