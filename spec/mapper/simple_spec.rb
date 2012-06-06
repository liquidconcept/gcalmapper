require 'spec_helper'

describe GcalMapper::Mapper::Simple do
  before :all do
    class User2
      include GcalMapper::Mapper::Simple
      attr_accessor :id, :first_name, :name

    end

    @base = GcalMapper::Mapper::Simple::Simple.new(User2)
  end

  it "should create a new object and save it" do
    @base.create!({'first_name' => 'a_name', 'name' => 'a_name'})
    @base.events.should_not eql([])
  end

  it "shoudl list all stored entry" do
     @base.find_all.should eql(@base.events)
  end

  it "should update an entry" do
    user = @base.events[0]
    name_before = user.name
    @base.update!(user.id, {'name' => 'another_name'})
    name_after = @base.events[0].name

    name_before.should_not eql(name_after)
  end

  it "should delete an entry" do
    @base.create!({'first_name' => 'a_name', 'name' => 'a_name'})
    before_count = @base.events.count
    user = @base.events[0]
    @base.delete!(user.id)

    before_count.should > (@base.events.count)
  end

  it "should find an entry from field name and value" do
    @base.create!({'first_name' => 'a_name', 'name' => 'another_name'})
    @base.create!({'first_name' => 'a_name', 'name' => 'different_name'})

    @base.find_by('name', 'a_name').should be_an_instance_of(User2)
  end

end