require 'spec_helper'

describe GcalMapper::Mapper do

  before :all do
    load File.dirname(__FILE__) + '/support/models/event.rb'
  end

  it "should load a file containing DSL with no error" do
    expect{load File.dirname(__FILE__) + '/support/models/event.rb'}.to_not raise_error
  end

  it "should save all events", :vcr do
    Event.synchronize_calendar
    Event.all.should_not eql([])
  end

  it "should save events only once", :vcr do
    before = Event.count
    Event.synchronize_calendar
    Event.count.should eq(before)
  end

  it "should erase cancelled event", :vcr do
    cancelled = 0
    Event.all.each do |event|
      cancelled += 1 if event.status == 'cancelled'
    end
    cancelled.should eq(0)
  end

end