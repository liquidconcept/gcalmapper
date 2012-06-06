require 'spec_helper'

describe GcalMapper::Authentification::Oauth2 do

  it "should have access_token attribute" do
    auth = GcalMapper::Authentification::Oauth2.new(@yaml)
    auth.should respond_to(:access_token)
  end

  it "should have refresh_token attribute", :vcr do
    auth = GcalMapper::Authentification::Oauth2.new(@yaml)
    auth.should respond_to(:refresh_token)
  end

end