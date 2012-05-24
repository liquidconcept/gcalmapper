require 'spec_helper'
require 'gcal_mapper/adapter'

describe GcalMapper::Adapter::ActiveRecord do

  before :all do
    class User < ActiveRecord::Base

    end

    @klass = GcalMapper::Adapter::ActiveRecord.new(User)
  end

  it "should create a new object and save it" do
    @klass.create!({'first_name' => 'a_name', 'name' => 'a_name'})
    User.all.should_not eql([])
  end

  it "shoudl list all stored entry" do
     @klass.find_all.should eql(User.all)
  end

  it "should update an entry" do
    user_before = User.first
    @klass.update!(user_before.id, {'name' => 'another_name'})
    user_after = User.first

    user_before.should eql(user_after)
  end

  it "should delete an entry" do
    user = User.first
    @klass.delete!(user.id)

    User.all.should eql([])
  end

  it "should find an entry from field name and value" do
    @klass.create!({'first_name' => 'a_name', 'name' => 'a_name'})
    @klass.create!({'first_name' => 'a_name', 'name' => 'another_name'})
    @klass.create!({'first_name' => 'a_name', 'name' => 'different_name'})

    @klass.find_by('name', 'a_name').should be_an_instance_of(User)
  end

end