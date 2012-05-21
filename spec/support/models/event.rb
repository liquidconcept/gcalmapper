require 'active_record'

class Event < ActiveRecord::Base

  include GcalMapper::Mapper

  calendar do
    configure :file => '/home/ndubuis/.google-api.yaml'

    calendar 'neville.dubuis@liquid-concept.ch'

    google_id 'gid'

    field 'name', :source => 'summary'
    field 'start_at', :source => 'start.dateTime'
    field 'end_at', :source => 'end.dateTime'
  end

end