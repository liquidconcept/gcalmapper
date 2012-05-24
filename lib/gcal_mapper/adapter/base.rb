module GcalMapper
  module Adapter
    #
    # Base class for adapters
    #
    class Base
      attr_reader :klass # class that sync need to use for sychronize event

      # execute when this class is inherited, add the adapter to the list of adapters
      #
      # @param [class] adapter calss of the adapter
      def self.inherited(adapter)
        Adapter.adapters << adapter
        super
      end

      # new object
      #
      # @param [class] klass class that need an adapter
      def initialize(klass)
        @klass = klass
      end

      # create and save object using attributes
      #
      # @param [Hash] attributes all the attributes to save in the new object
      def create!(attributes)
        raise NotImplementedError
      end

      # update an object
      #
      # @param [Int] id id of the object in the DB
      # @param [Hash] attributes hash containing the field to update
      def update!(id, attributes)
        raise NotImplementedError
      end

      # delet an object
      #
      # @param [Int] id id of the object in the DB
      def delete!(id)
        raise NotImplementedError
      end

      # Find all models
      #
      def find_all
        raise NotImplementedError
      end

      # find an object from his google id
      #
      # @param [String] field name of the field where gid is stored
      # @param [String] google_id the gid to find
      def find_by_google_id(field, google_id)
        raise NotImplementedError
      end

    end
  end
end