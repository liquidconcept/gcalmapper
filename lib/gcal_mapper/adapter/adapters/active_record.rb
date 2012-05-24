require 'active_record'

module GcalMapper
  module Adapter
    #
    # Adapter for ActiveRecord
    #
    class ActiveRecord < GcalMapper::Adapter::Base

      # create and save object using attributes
      #
      # @param [Hash] attributes all the attributes to save in the new object
      # return [Object] createrd object
      def create!(attributes)
        klass.create(attributes)
      end

      # update an object
      #
      # @param [Int] id id of the object in the DB
      # @param [Hash] attributes hash containing the field to update
      # @return [Object] updated object
      def update!(id, attributes)
        obj = klass.find(id)
        obj.update_attributes!(attributes)
      end

      # delet an object
      #
      # @param [Int] id id of the object in the DB
      # @return [Object] the destroyed object
      def delete!(id)
        obj = klass.find(id)
        obj.destroy
      end

      # Find all models
      #
      # @return [Array] all the object from a calss
      def find_all
        klass.all
      end

      # find an object from a field and a value
      #
      # @param [String] field name of the field where to search
      # @param [String] value the value to find
      # @return [Object] the finded object or nil
      def find_by(field, value)
        klass.send('find_by_' + field, value)
      end

    end
  end
end

#add all feature to ActiveRecord
ActiveSupport.on_load(:active_record) do
  extend ::GcalMapper::Adapter::ToAdapter
  self::Adapter = ::GcalMapper::Adapter::ActiveRecord
end