require 'spec_helper'

describe GcalMapper do
  before :all do
    @yaml = 'spec/file/.google-api.yaml'
    @calendar_id = ['neville.dubuis@liquid-concept.ch']
    @calendars_id = ['neville.dubuis@liquid-concept.ch', 'neville.dubuis@liquid-concept.ch']
  end
  
  it "should return the events list", :vcr do
    GcalMapper.fetch_events(@calendar_id, @yaml).should_not be_nil
  end
  
  it "should fetch multiple calendar", :vcr do
    GcalMapper.fetch_events(@calendars_id, @yaml).should_not be_nil
  end
  
  it "should raise error if calendar not accessible", :vcr do
    expect {GcalMapper.fetch_events(['test@test.com'], @yaml)}.to raise_error
  end
  
end