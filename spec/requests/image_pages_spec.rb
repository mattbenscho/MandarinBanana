# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Image pages" do
  before do
    @user = User.create(name: "Unique User", email: "unique@example.com", password: "foobar", password_confirmation: "foobar")
    @hanzi = Hanzi.create(character: "大", components: "")
    @gorodisha = Gorodish.create(element: "a4")
    @gorodishb = Gorodish.create(element: "d")
    @pydef = Pinyindefinition.create(hanzi_id: @hanzi.id, gbeginning: "d", gending: "a4", pinyin: "da4", definition: "bla")
    sign_in @user
    @mnemonic = @user.mnemonics.create(pinyindefinition_id: @pydef.id, gorodish_id: nil, aide: "Lorem Ipsum")
    visit hanzi_path(@hanzi)
    @url = "/mnemonics/" + @mnemonic.id.to_s + "/images/new"
  end
  
  subject { page }
  
  describe "hanzi: there should be a link to add a painting" do
    it { should have_link('add a painting', href: @url) }
  
    describe "hanzi: should encourage the user to draw something" do
      subject { page }
      before { first(:link, 'add a painting').click }
      it { should have_selector('h1', text: 'Paint something!') }
      describe "hanzi: after submitting an image, the user should land at the hanzi's page" do
        before do
          click_on "Save"
        end
        subject { page }
        it { should have_selector('h1', text: @hanzi.character) }
      end
    end
  end
  
  describe "gorodish: there should be a link to add a painting" do
    before do
      @mnemonic = @user.mnemonics.create(pinyindefinition_id: nil, gorodish_id: @gorodisha.id, aide: "Lorem Ipsum")
      @url = "/mnemonics/" + @mnemonic.id.to_s + "/images/new"
      visit gorodish_path(@gorodisha)
    end
    it { should have_link('add a painting', href: @url) }
  
    describe "gorodish: should encourage the user to draw something" do
      before { first(:link, 'add a painting').click }
      subject { page }
      it { should have_selector('h1', text: 'Paint something!') }
      
      describe "gorodish: after submitting an image, the user should land at the gorodish's page" do
        before do
          click_on "Save"
        end
        subject { page }
        before { @heading = "Gorodish element " + @gorodisha.element.to_s }
        it { should have_selector('h1', text: @heading) }
      end
    end
  end
end

