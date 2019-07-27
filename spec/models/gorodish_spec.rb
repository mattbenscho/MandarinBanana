require 'spec_helper'

describe Gorodish do
  let(:gorodish) { FactoryBot.create(:gorodish) }

  describe "it should have an element" do
    it { should respond_to(:element) }
  end
end
