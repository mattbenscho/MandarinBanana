# -*- coding: utf-8 -*-
require 'spec_helper'

describe "FeaturedImage pages" do
    
  let!(:gorodish_d) { FactoryBot.create(:gorodish, element: "d") }
  let!(:gorodish_a4) { FactoryBot.create(:gorodish, element: "a4") }
  let!(:fimage) { FactoryBot.create(:featured_image) }
  let!(:other_fimage) { FactoryBot.create(:featured_image) }
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:image) { FactoryBot.create(:image) }
  let(:hanzi) { FactoryBot.create(:hanzi) }
  let(:other_hanzi) { FactoryBot.create(:hanzi) }

  describe "anonymous user visiting hanzi without featured image" do
    before do
      visit hanzi_path(hanzi)
    end
    subject { page }
    it { should_not have_link('+F') }
    describe "manually visiting fimage new path" do
      before { visit "/featured_images/"  + image.id.to_s + "/new" }
      it "redirects" do
        expect(current_path).to eq signin_path
      end
    end
  end

  describe "signed in user" do
    before do 
      sign_in user
      visit hanzi_path(hanzi)
    end
    subject { page }
    it { should_not have_link('+F') }
    it { should_not have_link('Edit featured image') }
    describe "manually visiting fimage new path" do
      before { visit "/featured_images/"  + image.id.to_s + "/new" }
      it "redirects" do
        expect(current_path).to eq root_path
      end
    end
  end

  describe "as admin visiting a hanzi page" do
    before do
      @pd = hanzi.pinyindefinitions.create!(pinyin: "da4", definition: "bla", gbeginning: "d", gending: "a4")
      @mnemonic = @pd.mnemonics.create!(aide: "blabla", user: user)
      @image = @mnemonic.images.create!(data: "data:image/png;base64,ABCDEFG", user: user)
      sign_in admin
      visit hanzi_path(hanzi)
    end
    subject { page }
    it { should have_link('+F') }

    describe "creating a fimage" do
      before { click_link('+F', match: :first) }
      it { should have_content(hanzi.character) }
      it { should have_content(@mnemonic.aide) }
      before { fill_in "...", with: "some looooong text" }
      it "saving" do
        expect { click_button "Submit" }.to change(FeaturedImage, :count).by(1)
      end
    end

    describe "edit link" do
      before { visit featured_image_path(FeaturedImage.last) }
      it { should have_link('Edit featured image') }
      
      describe "edit view" do
        before { click_link('Edit featured image', match: :first) }
        it { should have_content('Edit featured image for ' + FeaturedImage.last.hanzi.character) }
      end
    end
  end

  describe "visiting a featured image" do

    let!(:last_fimage) { FactoryBot.create(:featured_image) }

    before { visit featured_image_path(fimage) }
    subject { page }
    it { should have_content(fimage.mnemonic_aide) }
    it { should have_content(fimage.commentary) }

    describe "prev next links first image" do
      it { should have_link(other_fimage.hanzi.character, href: featured_image_path(other_fimage)) }
      it { should have_link('»', href: featured_image_path(last_fimage)) }
      it { should_not have_link(fimage.hanzi.character, href: featured_image_path(fimage)) }
      it { should_not have_link('«', href: featured_image_path(fimage)) }
    end

    describe "prev next links last image" do
      before { visit featured_image_path(last_fimage) }
      it { should_not have_link(last_fimage.hanzi.character, href: featured_image_path(last_fimage)) }
      it { should_not have_link('»', href: featured_image_path(last_fimage)) }
      it { should have_link(other_fimage.hanzi.character, href: featured_image_path(other_fimage)) }
      it { should have_link('«', href: featured_image_path(fimage)) }
    end

    describe "index page" do
      let!(:other_fimage) { FactoryBot.create(:featured_image) }
      before do
        visit featured_images_path
      end
      subject { page }
      it { should have_content(fimage.hanzi.character) }
      it { should have_content(other_fimage.hanzi.character) }
    end
  end
end
