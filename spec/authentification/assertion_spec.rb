require 'spec_helper'

describe GcalMapper::Authentification::Assertion do

  it "should have access_token attribute", :vcr do
    auth = GcalMapper::Authentification::Assertion.new(@p12, @client_email, @user_email, 'notasecret')
    auth.should respond_to(:access_token)
  end

end