require 'spec_helper'

describe "Searchable" do

  it 'should searchable' do
    with_mocked_tables do |m|
      m.create_table do |t|
        t.model_name :FooSearchable

        t.layout do |l|
          l.string   :no
          l.integer  :count
          l.datetime :created_at
          l.datetime :updated_at
        end
      end

      class FooSearchable < ActiveRecord::Base
        include ModelConcerns::Searchable
        quick_search :no, :count
      end


      10.times do |index|
        FooSearchable.create(no: "NO#{index}", count: index)
      end

      expect(FooSearchable.search("9").count).to eq(1)
    end
  end
end