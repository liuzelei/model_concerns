# encoding: utf-8
require 'spec_helper'

describe "Searchable" do

  it 'should searchable' do
    with_mocked_tables do |m|
      m.create_table do |t|
        t.model_name :Foo

        t.layout do |l|
          l.string   :no
          l.integer  :count
          l.datetime :created_at
          l.datetime :updated_at
        end
      end

      class Foo < ActiveRecord::Base
        include ModelConcerns::Searchable
        quick_search :no, :count
      end


      10.times do |index|
        Foo.create(no: "NO#{index}", count: index)
      end

      expect(Foo.search("9").count).to eq(1)
    end
  end
end