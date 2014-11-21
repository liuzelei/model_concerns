require 'spec_helper'

describe "String" do

  it 'should xor' do
    left = "LEFT_STRING"
    right = "RIGHT_STRING"

    left = left ^ right
    expect(left).not_to eq("LEFT_STRING")
    right = right ^ left
    expect(right).to eq("LEFT_STRING")
    left = left ^ right
    expect(left).to eq("RIGHT_STRING")
    expect(right).to eq("LEFT_STRING")
  end
end