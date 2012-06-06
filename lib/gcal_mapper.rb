require 'gcal_mapper/version'
require 'gcal_mapper/rest_request'
require 'gcal_mapper/authentification'
require 'gcal_mapper/calendar'
require 'gcal_mapper/errors'
require 'gcal_mapper/sync'
require 'gcal_mapper/mapper'
require 'gcal_mapper/configuration'
require 'gcal_mapper/railtie' if defined?(Rails)

#
# A library to map Google Calendar events with an ORM.
#
module GcalMapper
end