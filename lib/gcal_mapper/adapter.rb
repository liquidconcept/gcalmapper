require 'gcal_mapper/adapter/base'
require 'gcal_mapper/adapter/to_adapter'

module GcalMapper
  #
  # Adapter to abstract orm
  #
  module Adapter

    # returns all registered adapters
    #
    # @return [Array] collection of registered adapters
    def self.adapters
      @@adapters ||= []
    end

  end
end

require 'gcal_mapper/adapter/adapters/active_record'