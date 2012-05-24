require 'spec_helper'

describe GcalMapper::Adapter::Base do
  before :all do
    class Dummy < GcalMapper::Adapter::Base
    end

    @dummy = Dummy.new(Object)
  end

  it "should raise error if create! don't exist" do
    expect {@dummy.create!({})}.to raise_error(NotImplementedError)
  end

  it "should raise error if update! don't exist" do
    expect {@dummy.update!(1, {})}.to raise_error(NotImplementedError)
  end

  it "should raise error if delete! don't exist" do
    expect {@dummy.delete!(1)}.to raise_error(NotImplementedError)
  end

  it "should raise error if find_all don't exist" do
    expect {@dummy.find_all}.to raise_error(NotImplementedError)
  end

  it "should raise error if find_by don't exist" do
    expect {@dummy.find_by('','')}.to raise_error(NotImplementedError)
  end
end