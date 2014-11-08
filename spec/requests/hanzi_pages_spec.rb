# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Hanzi pages" do

  before do
    @user = User.create!(name: "foobar", password: "foobar", email: "foobar@example.com", password_confirmation: "foobar")
    @hanzi = Hanzi.create!(character: "大", components: "")
    @pinyindefinition = @hanzi.pinyindefinitions.create!(pinyin: "da4")
    @mnemonic = @user.mnemonics.create!(aide: "Bla", pinyindefinition: @pinyindefinition)
    @fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @hanzi.id, commentary: "bla")
    @fimage.save
  end

  describe "searching for existing character" do
    before do
      visit root_url
      fill_in "character", with: "大"
      click_button "Go"
    end
    subject { page }
    it { should have_content(@hanzi.character) }
  end

  describe "searching for non-existing character" do
    before do
      visit root_url
      fill_in "character", with: "a"
      click_button "Go"
    end
    subject { page }
    it { should have_content("I didn't find anything") }
  end

end
