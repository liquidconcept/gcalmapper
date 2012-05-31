require 'spec_helper'

describe GcalMapper::Mapper::ActiveRecord do

  before :all do
    class User < ActiveRecord::Base

    end

    @klass = GcalMapper::Mapper::ActiveRecord::ActiveRecord.new(User)
  end

  it "should create a new object and save it" do
    @klass.create!({'first_name' => 'a_name', 'name' => 'a_name'})
    User.all.should_not eql([])
  end

  it "shoudl list all stored entry" do
     @klass.find_all.should eql(User.all)
  end

  it "should update an entry" do
    user = User.first
    name_before = user.name
    @klass.update!(user.id, {'name' => 'another_name'})
    name_after = User.first.name

    name_before.should_not eql(name_after)
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