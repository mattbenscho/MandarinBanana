# -*- coding: utf-8 -*-
require 'spec_helper'

describe FeaturedImage do

  let(:fimage) { FactoryBot.create(:featured_image) }

  subject { fimage }

  it { should respond_to(:data) }
  it { should respond_to(:mnemonic_aide) }
  it { should respond_to(:hanzi_id) }
  it { should respond_to(:commentary) }

end
