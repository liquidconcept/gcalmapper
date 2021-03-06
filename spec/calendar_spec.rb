require 'spec_helper'

describe GcalMapper::Calendar do
  before :all do
    @auth_oauth2 = GcalMapper::Authentification.new(@yaml)
    @auth_oauth2.authenticate
    @list = GcalMapper::Calendar.new
    @bad_token = 'a bad token'

  end

  it "should get the calendar list", :vcr do
    begin
      calendar = @list.get_calendars_list(@auth_oauth2.access_token)
    rescue
      @auth_oauth2.refresh_token
      calendar = @list.get_calendars_list(@auth_oauth2.access_token)
    end
    @list.get_calendars_list(@auth_oauth2.access_token).should_not be_nil
  end

  it "should get the events list", :vcr do
    @list.get_events_list(@auth_oauth2.access_token, @calendar_id).should_not be_nil
  end

  it "should raise error if the token is bad", :vcr do
    expect {@list.get_calendars_list(@bad_token)}.to raise_error
  end

  it "should raise error if the calendar id isn't accessible", :vcr do
    expect {@list.get_events_list(@auth_oauth2.access_token, 'test')}.to raise_error
  end
end