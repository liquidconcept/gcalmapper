module GcalMapper
  class Authbase
    def access_token
      raise NotImplementedError
    end
    
    def access_token= (acess_token)
      raise NotImplementedError
    end
  end
end