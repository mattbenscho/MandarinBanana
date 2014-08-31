# -*- coding: utf-8 -*-
require 'spec_helper'

describe Movie do

  let(:subtitle) { FactoryGirl.create(:subtitle) }
  let(:movie) { FactoryGirl.create(:movie) }

  subject { movie }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:subtitles) }
end
