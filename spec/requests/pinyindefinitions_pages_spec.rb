# -*- coding: utf-8 -*-
require 'spec_helper'

describe "homonyms" do
  let(:pd) { FactoryGirl.create(:pinyindefinition) }
  before { visit pinyindefinition_path(pd) }
  subject { page }
  it { should have_content(pd.hanzi.character) }  
end
