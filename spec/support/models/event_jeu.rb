require 'active_record'

class EventJeu < ActiveRecord::Base

  include GcalMapper::Mapper

  calendar do
    configure :file => '/home/ndubuis/Dev/gcalmapper/spec/file/privatekey2.p12',
              :client_email => '877466408867@developer.gserviceaccount.com',
              :user_email => 'webmaster@jeunesse-suhy.ch',
              :password => 'notasecret'

    calendar 'webmaster@jeunesse-suchy.ch'

    google_id 'gid'

    field 'name', :source => 'summary'
    field 'start_at', :source => 'start.dateTime'
    field 'end_at', :source => 'end.dateTime'
  end

end