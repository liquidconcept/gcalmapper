require 'spec_helper'

describe GcalMapper::Mapper::DSL do
  before :all do
    @dsl = GcalMapper::Mapper::DSL.new(GcalMapper::Configuration.new)
  end

  describe :field do
    it "should raise error if field option don't exist" do
      expect {@dsl.field('test', {:source => 'test', :test => 'test'})}.to raise_error
    end

    it "should accept :source, :match, :default" do
      expect {@dsl.field('test', {:source => 'test', :match => '/test/', :default => 'test'})}.to_not raise_error
    end

    it "should raise error if :source isn't present" do
      expect {@dsl.field('test', {:match => '/test/', :default => 'test'})}.to raise_error
    end
  end

  describe :configure do
    it "should raise an error if :file isn't present" do
      expect {@dsl.configure({:client_email => '87', :user_email => 'web', :password => 'notasecret'})}.to raise_error
    end
  end
end