# # encoding: utf-8
# require 'spec_helper'

# # describe 'test sequenceable' do

# #   class TestMe < ActiveRecord::Base
# #     include ModelConcerns::Sequenable
# #     sequence :TM
# #   end

# #   it 'should generate code' do
# #     test_me = TestMe.new
# #     test
# #   end
# # end


# describe "Sequenable" do

#   it 'should generate code' do
#     with_mocked_tables do |m|
#       # m.enable_extension "uuid-ossp"
#       # m.enable_extension "hstore"

#       t1 = m.create_table do |t|
#         t.model_name :Foo
#         t.belongs_to :bar

#         t.layout do |l|
#            l.integer :bar_id
#         end
#       end

#       t2 = m.create_table do |t|
#         t.model_name :Bar
#         t.has_many   :foo

#         t.layout do |l|
#           l.text :bar_text
#         end
#       end

#       # Do Work Here
#     end

#   end
# end