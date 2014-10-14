# -*- coding: utf-8 -*-
require 'spec_helper'

describe "FeaturedImage pages" do
  before do
    @user = User.create!(name: "foobar", password: "foobar", email: "foobar@example.com", password_confirmation: "foobar")
    @hanzi = Hanzi.create!(character: "大", components: "")
    @other_hanzi = Hanzi.create!(character: "b", components: "")
    @pinyindefinition = @hanzi.pinyindefinitions.create!(pinyin: "da4")
    @mnemonic = @user.mnemonics.create!(aide: "Bla", pinyindefinition: @pinyindefinition)
    @fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @hanzi.id, commentary: "bla")
    @fimage.save
    @other_fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @other_hanzi.id, commentary: "bla")
    @other_fimage.save
    @last_fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @other_hanzi.id, commentary: "blubb")
    @last_fimage.save
  end

  describe "visiting a featured image" do
    before { visit featured_image_path(@fimage) }
    subject { page }
    it { should have_content(@fimage.mnemonic_aide) }
    it { should have_content(@fimage.commentary) }

    describe "prev next links first image" do
      it { should have_link('›', href: featured_image_path(@other_fimage)) }
      it { should have_link('»', href: featured_image_path(@last_fimage)) }
      it { should_not have_link('‹', href: featured_image_path(@fimage)) }
      it { should_not have_link('«', href: featured_image_path(@fimage)) }
    end

    describe "prev next links last image" do
      before { visit featured_image_path(@last_fimage) }
      it { should_not have_link('›', href: featured_image_path(@last_fimage)) }
      it { should_not have_link('»', href: featured_image_path(@last_fimage)) }
      it { should have_link('‹', href: featured_image_path(@other_fimage)) }
      it { should have_link('«', href: featured_image_path(@fimage)) }
    end
  end


end
