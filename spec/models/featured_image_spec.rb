# -*- coding: utf-8 -*-
require 'spec_helper'

describe FeaturedImage do

  before do 
    @user = User.create!(name: "foobar", password: "foobar", email: "foobar@example.com", password_confirmation: "foobar")
    @hanzi = Hanzi.create!(character: "大", components: "")
    @pinyindefinition = @hanzi.pinyindefinitions.create!(pinyin: "da4")
    @mnemonic = @user.mnemonics.create!(aide: "Bla", pinyindefinition: @pinyindefinition)
    @fimage = FeaturedImage.new(data: "data:image/png;base64,ABCDEFG", mnemonic_aide: @mnemonic.aide, hanzi_id: @hanzi.id, commentary: "bla")
  end

  subject { @fimage }

  it { should respond_to(:data) }
  it { should respond_to(:mnemonic_aide) }
  it { should respond_to(:hanzi_id) }
  it { should respond_to(:commentary) }

end
