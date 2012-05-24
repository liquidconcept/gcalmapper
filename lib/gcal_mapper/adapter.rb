require 'gcal_mapper/adapter/base'
require 'gcal_mapper/adapter/to_adapter'

module GcalMapper
  module Adapter
    # A collection of registered adapters
    def self.adapters
      @@adapters ||= []
    end

    # All model classes from all registered adapters
    def self.model_classes
      self.adapters.map { |a| a.model_classes }.flatten
    end
  end
end

require 'gcal_mapper/adapter/adapters/active_record'