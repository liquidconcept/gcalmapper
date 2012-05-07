require 'spec_helper'

describe GcalMapper do
  before :all do
    @calendars_id = [].push(@calendar_id).push(@calendar_id)
  end
  
  it "should return the events list", :vcr do
    GcalMapper.fetch_events([].push(@calendar_id), @yaml).should_not be_nil
  end
  
  it "should fetch multiple calendar", :vcr do
    GcalMapper.fetch_events(@calendars_id, @yaml).should_not be_nil
  end
  
  it "should raise error if calendar not accessible", :vcr do
    expect {GcalMapper.fetch_events(['test@test.com'], @yaml)}.to raise_error
  end
  
end