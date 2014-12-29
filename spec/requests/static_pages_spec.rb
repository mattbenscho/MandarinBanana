# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Static pages" do
  before do
    @user = User.create!(name: "foobar", password: "foobar", email: "foobar@example.com", password_confirmation: "foobar")
    @hanzi = Hanzi.create!(character: "大", components: "")
    @pinyindefinition = @hanzi.pinyindefinitions.create!(pinyin: "da4")
    @mnemonic = @user.mnemonics.create!(aide: "Bla", pinyindefinition: @pinyindefinition)
    @fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @hanzi.id, commentary: "bla")
    @fimage.save
  end

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('MandarinBanana') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

end
