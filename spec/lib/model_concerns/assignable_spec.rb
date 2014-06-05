# encoding: utf-8
require 'spec_helper'

describe "Assignable" do

  it 'should assign' do
    with_mocked_tables do |m|
      m.create_table do |t|
        t.model_name :Foo

        t.layout do |l|
          l.integer  :owner_id
          l.string   :owner_no
          l.integer  :manager_id
          l.string   :manager_no
          l.datetime :created_at
          l.datetime :updated_at
        end
      end

      m.create_table do |t|
        t.model_name :User
        t.layout do |l|
          l.string :no
        end
      end

      class User < ActiveRecord::Base
      end

      class Foo < ActiveRecord::Base
        include ModelConcerns::Assignable
        has :owner, :manager
      end

      u1 = User.create(no: "NO1")
      u2 = User.create(no: "NO2")
      f = Foo.create(owner: u1, manager: u2)

      expect(Foo.filter_by_owner(u1).count).to eq(1)
      expect(Foo.filter_by_owner(u1).count).to eq(1)
      expect(Foo.filter_by_manager(u2).count).to eq(1)
      expect(Foo.filter_by_manager(u2).count).to eq(1)

      f.assign_owner(u2)
      expect(f.owner.id).to eq(u2.id)
      f.reload
      expect(f.owner.id).to eq(u1.id)
      f.assign_owner(u2)
      f.save
      expect(f.owner.id).to eq(u2.id)

      f.assign_owner!(u1)
      f.reload
      expect(f.owner.id).to eq(u1.id)
    end
  end
end