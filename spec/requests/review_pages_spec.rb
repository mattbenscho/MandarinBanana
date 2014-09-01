# -*- coding: utf-8 -*-
require 'spec_helper'

describe "ReviewPages" do
  let(:user) { FactoryGirl.create(:user) }
  let(:hanzi) { FactoryGirl.create(:hanzi) }
  before { sign_in user }
  before { @review = user.reviews.create(hanzi: hanzi) }
  before { visit review_path(@review) }

  subject { page }

  it "should have a progress bar" do
    find('#meter').should have_content('')
  end

  
end
