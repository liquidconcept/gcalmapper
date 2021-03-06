require 'spec_helper'

describe GcalMapper::Authentification::Base do
  before :all do
    class DummyClass < GcalMapper::Authentification::Base
    end

    @dummy = DummyClass.new
  end

  it "should raise error if access_token don't exist" do
    expect {@dummy.access_token}.to raise_error(NotImplementedError)
  end

  it "should raise error if refresh_token don't exist" do
    expect {@dummy.refresh_token}.to raise_error(NotImplementedError)
  end
end