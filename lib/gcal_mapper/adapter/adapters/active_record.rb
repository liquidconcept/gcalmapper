require 'active_record'

module GcalMapper
  module Adapter
    class ActiveRecord < GcalMapper::Adapter::Base

      def create!(attributes)
        klass.create(attributes)
      end

      def update!(id, attributes)
        obj = klass.find(id)
        obj.update_attributes!(attributes)
      end

      def delete!(id)
        obj = klass.find(id)
        obj.destroy
      end

      def find_all
        klass.all
      end

      def find_by_google_id(field, google_id)
        Event.send('find_by_' + field, google_id)
      end

    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend ::GcalMapper::Adapter::ToAdapter
  self::Adapter = ::GcalMapper::Adapter::ActiveRecord
end