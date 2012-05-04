require 'spec_helper'

describe GcalMapper::Authentification do
  
  it "should raise an error if the file is don't exist" do
    expect {GcalMapper::Authentification.new('/home/test')}.to raise_error
  end
  
  it "should return an error if bad yaml file is given" do
    auth = GcalMapper::Authentification.new(@bad_yaml)
    expect {auth.authenticate}.to raise_error
  end
  
  it "should not raise an error if relative path is given" do
    auth = GcalMapper::Authentification.new(@yaml_relative)
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