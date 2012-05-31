require 'spec_helper'

describe GcalMapper::Sync do
  before(:each) do
    GcalMapper::Sync.send(:public, *GcalMapper::Sync.private_instance_methods)
  end

  it "should raise error if regexp is not valid" do
    sync = GcalMapper::Sync.new(nil, nil)
    expect {sync.eval_value({:source => 'test', :match => test, :default => 'category: test'}, 'test')}.to raise_error
  end

  it "should return default if no match" do
    sync = GcalMapper::Sync.new(nil, nil)
    sync.eval_value({:source => 'test', :match => /^category: (.*)$/, :default => 'default'}, 'test').should eq('default')
  end

  it "should return match" do
    sync = GcalMapper::Sync.new(nil, nil)
    sync.eval_value({:source => 'test', :match => /^test$/, :default => 'default'}, 'test').should eq('test')
  end

  it "should raw data if no regexp given" do
    sync = GcalMapper::Sync.new(nil, nil)
    sync.eval_value({:source => 'test'}, 'raw').should eq('raw')
  end
end