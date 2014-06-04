# encoding: utf-8
require 'spec_helper'

describe "Sequenable" do

  it 'should sequence' do
    with_mocked_tables do |m|
      m.create_table do |t|
        t.model_name :Foo

        t.layout do |l|
          l.string  :no
          l.datetime :created_at
          l.datetime :updated_at
        end
      end

      class Foo < ActiveRecord::Base
        include ModelConcerns::Sequenable
        sequence :FO
      end

      puts "this test will execute in long time, please wait"
      threads = []
      100.times do
        threads << Thread.new do
          100.times do
            Foo.new.save
          end
        end
      end

      threads.each do |thread|
        thread.join
      end

      expect(Foo.all.count).to eq(10000)

      expect(Foo.select("count(1) as count, no").group("no").having("count(1) > 1").length).to eq(0)
    end
  end
end