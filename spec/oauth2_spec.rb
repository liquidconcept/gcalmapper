require 'spec_helper'

describe GcalMapper::Authentification::Oauth2 do
  before :all do
    @yaml = 'spec/file/.google-api.yaml'
  end
  
  it "should have access_token attribute", :vcr do
    auth = GcalMapper::Authentification::Oauth2.new(@yaml)
    auth.should respond_to(:access_token)
  end
end