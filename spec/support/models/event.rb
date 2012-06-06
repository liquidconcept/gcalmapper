require 'active_record'

class Event < ActiveRecord::Base

  include GcalMapper::Mapper::ActiveRecord

  calendar do
    configure :file => 'spec/file/auth.yaml'

    calendar 'neville.dubuis@liquid-concept.ch'
    calendar 'neville.dubuis@liquid-concept.ch'

    google_id 'gid'

    field 'name', :source => 'summary'
    field 'description', :source => 'description',
                         :match => /^category: (.*)$/, :default => 'not categorized'
    field 'status', :source => 'status'
    field 'start_at', :source => 'start.dateTime'
    field 'end_at', :source => 'end.dateTime'
    field 'created_at', :source => 'created'
    field 'updated_at', :source => 'updated'
  end

end