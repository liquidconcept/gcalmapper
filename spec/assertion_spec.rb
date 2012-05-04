require 'spec_helper'

describe GcalMapper::Authentification::Assertion do
  before :all do
    @p12 = 'spec/file/privatekey.p12'
    @client_email = '491507701942-7bc0pf4187fooffdqp6ao1a0b81v6aj2@developer.gserviceaccount.com'
  end
  
  it "should have access_token attribute", :vcr do
    auth = GcalMapper::Authentification::Assertion.new(@p12, @client_email)
    auth.should respond_to(:access_token)
  end
end