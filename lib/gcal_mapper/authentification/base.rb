module GcalMapper
  class Authentification
    #
    # Base class for authentification methods
    #
    class Base

      # raise error if this method is called -> mean that child class has not implemeted this method
      def access_token
        raise NotImplementedError
      end

      # raise error if this method is called -> mean that child class has not implemeted this method
      def refresh_token
        raise NotImplementedError
      end

    end
  end
end