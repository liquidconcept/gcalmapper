require 'spec_helper'

describe GcalMapper::Authentification do
  before :all do
    @yaml = 'spec/file/.google-api.yaml'
    @yaml2 = '~/.google-api.yaml'
    @bad_yaml = 'spec/file/test.yaml'
    @p12 = 'spec/file/privatekey.p12'
    @client_email = '491507701942-7bc0pf4187fooffdqp6ao1a0b81v6aj2@developer.gserviceaccount.com'
  end
  
  it "should raise an error if the file is don't exist" do
    expect {GcalMapper::Authentification.new('/home/test')}.to raise_error
  end
  
  it "should return an error if bad yaml file is given" do
    auth = GcalMapper::Authentification.new(@bad_yaml)
    expect {auth.authenticate}.to raise_error
  end
  
  it "should not raise an error if relative path is given" do
    auth = GcalMapper::Authentification.new(@yaml2)
    expect {auth.authenticate}.to_not raise_error
  end
    
  it "access token should exist with oauth2 auth" do
    auth = GcalMapper::Authentification.new(@yaml)
    auth.authenticate.should be_true
  end

  it "access token should exist with assertion auth", :vcr do
    auth = GcalMapper::Authentification.new(@p12, @client_email)
    auth.authenticate.should be_true
  end
  
  it "should be fasle if bad client email is given", :vcr do
    auth = GcalMapper::Authentification.new(@p12, 'test@dtest.com')
    expect {auth.authenticate}.to raise_error
  end
end