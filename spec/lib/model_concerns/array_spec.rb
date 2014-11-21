require 'spec_helper'

describe "Array" do

  it 'should trim head' do
    array = [0, 0, nil, 1, 2, 3]
    expect(array.trim_head).to eq([1, 2, 3])
    expect(array).to eq([0, 0, nil, 1, 2, 3])
  end
end