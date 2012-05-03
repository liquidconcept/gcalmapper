require 'spec_helper'

describe GcalMapper::Base do
  before :all do
    class DummyClass < GcalMapper::Base
    end
    
    @dummy = DummyClass.new
  end
  
  it "should raise error if access_token don't exist" do
    expect {@dummy.access_token}.to raise_error(NotImplementedError)
  end
  
  it "should raise error if access_token= don't exist" do
    expect {@dummy.access_token='test'}.to raise_error(NotImplementedError)
  end
end