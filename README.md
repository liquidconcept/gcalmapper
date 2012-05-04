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

**TODO**

Test
----

TO launch test yourself, you need somme file and some and google API acess via 
theconsole. 

don't forget 

    $ bundle install

then go to : https://code.google.com/apis/console and open a new api account :

1. click on "Services" on the rigth top menu
2. click on the toggle button next to "Calendar API"
3. accept the license
4. click on "API Access" on the rigth top menu
5. click on the blue button "Create an Oauth2.0 Client ID ..."
6. provide a name for the API and click next
7. chose the type between "service account" and "installed app" *
8. click "create client id"

* For testing purpose you need to do both, don't forget to save the file that
google ask to download. You can use service account only if you manage your 
domain with google. But you have to go to your google apps manager :

1. go to "Advenced tools" -> "Manage api client acess"
2. enter your client id(service account) in "client name"
3. enter "http(s)://www.google.com/calendar/feeds/" in "scope"
4. click "authorize"

Now you can access google calendar with this api

copy the file ".p12" to spec/file/privatekey.p12

execute(all on the same lien) with the data of the installed app
    
    google-api oauth-2-login --scope=https://www.googleapis.com/auth/calendar --client-id=[CLIENT_ID] --client-secret=[CLIENT_SECRET]

it should open a new page, click accept that the API acess your data.
this gives you ~/.google-api.yaml copy it on spec/file/.google-api.yaml

then open spec/spec_helper.rb and change :

    config.before :all do
        @p12 = 'spec/file/privatekey.p12' -> don't change
        @client_email = '[your service account's email address]'
        @user_email = '[email address that your service account can impersonate]'
        @yaml = 'spec/file/.google-api.yaml' -> don't change
        @yaml_relative = '~/.google-api.yaml' -> don't chang
        @bad_yaml = 'spec/file/bad_yaml.yaml' -> create an empty file
        @calendar_id = '[an accesible calendar id, possibly the same at user email]'
    end

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
