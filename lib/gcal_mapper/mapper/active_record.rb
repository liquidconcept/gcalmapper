require 'active_record'

module GcalMapper
  module Mapper
    #
    # module to include when active record is in use
    #
    module ActiveRecord

      # execute when the file is included
      #
      # @param [Class] base class of the includer
      def self.included(base)
        base.extend(GcalMapper::Mapper::ClassMethods)
        Mapper.base = base
        Mapper.adapter = ActiveRecord.new(base)
      end

      #
      # Adapter for ActiveRecord
      #
      class ActiveRecord

        def initialize(base)
          @base = base
        end

        # create and save object using attributes
        #
        # @param [Hash] attributes all the attributes to save in the new object
        # return [Object] createrd object
        def create!(attributes)
          @base.create(attributes)
        end

        # update an object
        #
        # @param [Int] id id of the object in the DB
        # @param [Hash] attributes hash containing the field to update
        # @return [Object] updated object
        def update!(id, attributes)
          obj = @base.find(id)
          obj.update_attributes!(attributes)
        end

        # delet an object
        #
        # @param [Int] id id of the object in the DB
        # @return [Object] the destroyed object
        def delete!(id)
          obj = @base.find(id)
          obj.destroy
        end

        # Find all models
        #
        # @return [Array] all the object from a calss
        def find_all
          @base.all
        end

        # find an object from a field and a value
        #
        # @param [String] field name of the field where to search
        # @param [String] value the value to find
        # @return [Object] the finded object or nil
        def find_by(field, value)
          @base.send('find_by_' + field, value)
        end

      end
    end
  end
end