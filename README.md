gcalMapper
==========

A library to map Google Calendar events with an ORM.

Installation
------------

Add this line to your application's Gemfile:

    gem 'gcalmapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gcalmapper

Usage
-----

### Authorization to connect to gcal ##

To have access to your google calendar go to :

[Google API Console][1]

and open a new api account :

1. click on "Services" on the rigth top menu
2. click on the toggle button next to "Calendar API"
3. accept the license
4. click on "API Access" on the rigth top menu
5. click on the blue button "Create an Oauth2.0 Client ID ..."
6. provide a name for the API and click next
7. chose the type between "service account" and "installed app"
8. click "create client id"

for now we recommend to open an installed app account, the service account don't work anymore with google calendar.

once you have your "installed app" access run :

    $ gcal-mapper --client_id [CLIENT_ID] --client_secret [CLIENT_SECRET]

it should open a new page, click accept that the API acess your data.
this gives you ~/google_auth.yaml copy it on spec/file/google_auth.yaml
(you can change path with --file /path/to/the/yaml_file.yaml)
(you can change scope with --scope https://www.googleapis.com/another/scope)

with the service account make sure you save well the private key.
You can use service account only if you manage your
domain with google. But you have to go to your google apps manager :

1. go to "Advenced tools" -> "Manage api client acess"
2. enter your client id(service account) in "client name"
3. enter "http(s)://www.google.com/calendar/feeds/" in "scope"
4. click "authorize"

### exemple ##

when you manage to have the authorization to access your google calendar create your model

    require 'active_record'

    class Event < ActiveRecord::Base

      include GcalMapper::Mapper::ActiveRecord

      calendar do
        configure :file => 'path/to/your/yaml/file.yaml'

        calendar 'your_email@gmail.com'

        google_id 'gid'

        field 'name', :source => 'summary'
        field 'description', :source => 'description',
                             :match => /^category: (.*)$/, :default => 'not categorized'
        field 'status', :source => 'status'
        field 'start_at', :source => 'start.dateTime', :if_empty => 'start.date'
        field 'end_at', :source => 'end.dateTime', :if_empty => 'end.date'
        field 'created_at', :source => 'created'
        field 'updated_at', :source => 'updated'
      end

      def self.synchronize_me
        self.synchronize_calendar
      end

    end

here is an example with Oauth2.0 authentification for installed app, as you can see it'is not a rails model and it work with AtiveRecord.

you can find an exemple with rails there :

[GcalMapper Rails exemple][3]

### configure ##

`configure` is used to set your crendentials. You can see above an exemple for "installed app" here is one for "service account" :

    configure :file => '/path/to/the/private-key.p12',
              :client_email => 'service_account_email',
              :user_email => 'user@yourdomain.com',
              :password => 'password of your key'

`:password` is optional the default value is 'notasecret'


### google_id ##

`google_id` must be present, and you must give it the name of an existing string field in your DB. it store the  google event id and must be saved to keep your DB synchronize


### calendar ##

if you want to synchronize more than one calendar just do someting like :

    calendar 'your_email@gmail.com'
    calendar 'other_accessible_calendar@gmail.com


### field ##

the minimal `field` declatration is

    field 'name_of_your_db_column', :source => 'name_of_the_source'

It is possible to be more precise with the use of `:match` and `:default`

 - `:match => 'regexp'` is used to parse
   only a part of the google data
 - `:default => 'default` is used to put default data in case of unmatching data

Both are optional, but if you use `:match` without `:default`, the default value will be `nil`

if the data you want to save is not always setted, it'is possible to use `:if_empty`.
this will try to take data in another field if the source is empty. in the exemple you
can see the usage as date.dateTime is not always present (for exemple long event that only
date of start and date of end without hours).


Compatibility
-------------

For now GcalMapper is only compatible with :

- ActiveRecord

it can be extended quite easly

it is possible to use GcalMapper without ORM, juste include

    GcalMapper::Mapper::Simple

like this :

    class Event
      attr_accessor :id, :gid, :name, :description, :status, :start_at, :end_at, :created_at, :upated_at
      include GcalMapper::Mapper::Simple

      calendar do

        configure :file => 'path/to/your/yaml/file.yaml'

        calendar 'your_email@gmail.com'

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

      def self.synchronize_me
        self.synchronize_calendar
      end

    end


Source data reference
---------------------

here is the reference for the source data :

    {
      "kind": "calendar#event",
      "etag": etag,
      "id": string,
      "status": string,
      "htmlLink": string,
      "created": datetime,
      "updated": datetime,
      "summary": string,
      "description": string,
      "location": string,
      "colorId": string,
      "creator": {
        "email": string,
        "displayName": string
      },
      "organizer": {
        "email": string,
        "displayName": string
      },
      "start": {
        "date": date,
        "dateTime": datetime,
        "timeZone": string
      },
      "end": {
        "date": date,
        "dateTime": datetime,
        "timeZone": string
      },
      "recurrence": [
        string
      ],
      "recurringEventId": string,
      "originalStartTime": {
        "date": date,
        "dateTime": datetime,
        "timeZone": string
      },
      "transparency": string,
      "visibility": string,
      "iCalUID": string,
      "sequence": integer,
      "attendees": [
        {
          "email": string,
          "displayName": string,
          "organizer": boolean,
          "self": boolean,
          "resource": boolean,
          "optional": boolean,
          "responseStatus": string,
          "comment": string,
          "additionalGuests": integer
        }
      ],
      "attendeesOmitted": boolean,
      "extendedProperties": {
        "private": {
          (key): string
        },
        "shared": {
          (key): string
        }
      },
      "gadget": {
        "type": string,
        "title": string,
        "link": string,
        "iconLink": string,
        "width": integer,
        "height": integer,
        "display": string,
        "preferences": {
          (key): string
        }
      },
      "anyoneCanAddSelf": boolean,
      "guestsCanInviteOthers": boolean,
      "guestsCanModify": boolean,
      "guestsCanSeeOtherGuests": boolean,
      "privateCopy": boolean,
      "reminders": {
        "useDefault": boolean,
        "overrides": [
          {
            "method": string,
            "minutes": integer
          }
        ]
      }
    }

for now you can access nearly all the data. you can acces all the the first and second degree key.

if you want the summary :

    field 'summary', :source => 'summary'

for the creator email :

    field 'creator_email', :source => 'creator.email'

if you just put `creator` it will give your the string dump of

    "organizer": {
      "email": string,
      "displayName": string
    },

that will look like :

    "{\"email\"=>\"string\", \"displayName\"=>\"string\"}"

for things like `attendees` or `extendedProperties`, the only way of saving it is to save the string dump of that

for `attendees` :

    field 'attendees_dump', :source 'attendees'

for `extendedProperties` you can do `extendedProperties.private` but `extendedProperties.private.(field)` will not work


Test
----

To launch test yourself, you need somme file and some and google API acess via
the console.

don't forget

    $ bundle install

then go to : https://code.google.com/apis/console and open a new api account :

1. click on "Services" on the rigth top menu
2. click on the toggle button next to "Calendar API"
3. accept the license
4. click on "API Access" on the rigth top menu
5. click on the blue button "Create an Oauth2.0 Client ID ..."
6. provide a name for the API and click next
7. chose the type between "service account" and "installed app"
8. click "create client id"

For testing purpose you need to do both, don't forget to save the file that
google ask to download. You can use service account only if you manage your
domain with google. But you have to go to your google apps manager :

1. go to "Advenced tools" -> "Manage api client acess"
2. enter your client id(service account) in "client name"
3. enter "http(s)://www.google.com/calendar/feeds/" in "scope"
4. click "authorize"

Now you can access google calendar with this api

copy the file ".p12" to spec/file/privatekey.p12

execute, with the data of the installed app

    gcal-mapper --client_id [CLIENT_ID] --client_secret [CLIENT_SECRET]

it should open a new page, click accept that the API acess your data.
this gives you ~/google_auth.yaml copy it on spec/file/google_auth.yaml
(you can change path with --file /path/to/the/yaml_file.yaml)
(you can change scope with --scope https://www.googleapis.com/another/scope)

then create spec/file/config.yaml, must look like this :

    p12: 'spec/file/privatekey.p12'     -> path to your p12 key
    p12_2: 'spec/file/privatekey2.p12'  -> path to a second one, can be the same
    client_email: '[your service account's email address]'
    user_email: '[email address that your service account can impersonate]'
    yaml: 'spec/file/google_auth.yaml'  -> or another path
    yaml_relative: '~/google_auth.yaml' -> or another path, relative
    bad_yaml: 'spec/file/bad_yaml.yaml' -> create an empty file
    calendar_id: '[an accesible calendar id, possibly the same at user email]'

then run

    rake spec

test's are running!

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Copyright & License
-------------------

Copyright (c) 2012 Liquid Concept. See LICENSE for details.


  [1]: https://code.google.com/apis/console
  [2]: https://developers.google.com/google-apps/calendar/v3/reference/events?hl=fr-FR
  [3]: https://github.com/ndubuis/gcal_mapper-exemple