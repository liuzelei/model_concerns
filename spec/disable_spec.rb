# encoding: utf-8
require 'spec_helper'

describe "Disable" do

  it 'should disable' do
    with_mocked_tables do |m|
      t1 = m.create_table do |t|
        t.model_name :Foo
        t.belongs_to :bar

        t.layout do |l|
           l.integer :bar_id
        end
      end
    end

  puts "-------"
  end
end