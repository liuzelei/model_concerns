require 'spec_helper'

describe "Sequenable" do

  it 'should sequence' do
    with_mocked_tables do |m|
      m.create_table do |t|
        t.model_name :FooSequenable

        t.layout do |l|
          l.string  :no
          l.datetime :created_at
          l.datetime :updated_at
        end
      end

      class FooSequenable < ActiveRecord::Base
        include ModelConcerns::Sequenable
        sequence :FO
      end

      puts "this test will take a long time, please wait....."
      pids = []
      10.times do
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.connection_config)

        pids << fork do

          threads = []
          10.times do
            threads << Thread.new do
              100.times do
                FooSequenable.new.save
              end
            end
          end

          threads.each do |thread|
            thread.join
          end
        end
      end

      pids.each do |pid|
        Process.waitpid(pid)
      end

      expect(FooSequenable.all.count).to eq(10000)

      expect(FooSequenable.select("count(1) as count, no").group("no").having("count(1) > 1").length).to eq(0)
    end
  end
end