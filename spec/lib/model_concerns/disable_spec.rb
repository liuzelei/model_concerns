# encoding: utf-8
require 'spec_helper'

describe "Disable" do

  it 'should disable' do
    with_mocked_tables do |m|
      m.create_table do |t|
        t.model_name :Foo

        t.layout do |l|
          l.integer  :no
          l.datetime :created_at
          l.datetime :updated_at
          l.datetime :disabled_at
        end
      end

      class Foo < ActiveRecord::Base
        include ModelConcerns::Disable
      end

      10.times.each do |index|
        Foo.create(no: index)
      end

      5.times.each do |index|
        Foo.create(no: index + 10).disable!
      end

      expect(Foo.disabled.count).to eq(5)
      expect(Foo.enabled.count).to eq(10)
      
      f = Foo.find_by_no(5)
      f.disable
      expect(f.disabled?).to eq(true)
      f.reload
      expect(f.disabled?).to eq(false)
      f.disable!
      expect(f.disabled?).to eq(true)
      f.reload
      expect(f.disabled?).to eq(true)

      f = Foo.find_by_no(11)
      f.enable
      expect(f.disabled?).to eq(false)
      f.reload
      expect(f.disabled?).to eq(true)
      f.enable!
      expect(f.disabled?).to eq(false)
      f.reload
      expect(f.disabled?).to eq(false)
    end
  end
end