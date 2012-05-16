require 'spec_helper'

describe GcalMapper::Sync do

  before :all do
    ActiveRecord::Base.establish_connection(
       :adapter => "sqlite3",
       :database => File.dirname(__FILE__) + "/test.sqlite3"
    )
    load File.dirname(__FILE__) + '/support/schema.rb'
    load File.dirname(__FILE__) + '/support/models/event.rb'
  end

  pending "should save all events" do

  end

end