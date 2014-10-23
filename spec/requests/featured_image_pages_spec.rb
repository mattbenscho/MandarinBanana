# -*- coding: utf-8 -*-
require 'spec_helper'

describe "FeaturedImage pages" do
  before do
    @user = User.create!(name: "foobar", password: "foobar", email: "foobar@example.com", password_confirmation: "foobar")
    @hanzi = Hanzi.create!(character: "大", components: "")
    @other_hanzi = Hanzi.create!(character: "一", components: "")
    @pinyindefinition = @hanzi.pinyindefinitions.create!(pinyin: "da4")
    @mnemonic = @user.mnemonics.create!(aide: "Bla", pinyindefinition: @pinyindefinition)
    @fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @hanzi.id, commentary: "bla")
    @fimage.save
    @other_fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @other_hanzi.id, commentary: "bla")
    @other_fimage.save
    @last_fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @other_hanzi.id, commentary: "blubb")
    @last_fimage.save
    @image = @user.images.create!(data: "data:image/png;base64,ABCDEFG", mnemonic: @mnemonic)
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

  describe "anonymous user" do
    before do
      visit hanzi_path(@hanzi)
    end
    subject { page }
    it { should_not have_link('+F') }
    describe "manually visiting fimage new path" do
      before { visit "/featured_images/"  + @image.id.to_s + "/new" }
      it "redirects" do
        expect(current_path).to eq signin_path
      end
    end
  end

  describe "signed in user" do
    before do 
      sign_in @user
      visit hanzi_path(@hanzi)
    end
    subject { page }
    it { should_not have_link('+F') }
    it { should_not have_link('Edit featured image') }
    describe "manually visiting fimage new path" do
      before { visit "/featured_images/"  + @image.id.to_s + "/new" }
      it "redirects" do
        expect(current_path).to eq featured_image_path(@last_fimage)
      end
    end
  end

  describe "as admin" do

    let(:admin) { FactoryGirl.create(:admin) }

    before do
      sign_in admin
      visit hanzi_path(@hanzi)
    end
    subject { page }
    it { should have_link('+F') }

    describe "creating" do
      before { click_link('+F', match: :first) }
      it { should have_content(@hanzi.character) }
      it { should have_content(@mnemonic.aide) }
      before { fill_in "...", with: "some looooong text" }
      it "saving" do
        expect { click_button "Submit" }.to change(FeaturedImage, :count).by(1)
      end
    end

    describe "edit link" do
      before { visit root_path }
      it { should have_link('Edit featured image') }
      
      describe "edit view" do
        before { click_link('Edit featured image', match: :first) }
        it { should have_content('Edit featured image for ' + @other_hanzi.character) }
      end
    end
  end

  describe "index page" do
    before do
      visit featured_images_path
    end
    subject { page }
    it { should have_content(@hanzi.character) }
    it { should have_content(@other_hanzi.character) }
  end
end
