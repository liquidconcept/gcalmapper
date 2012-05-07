

module GcalMapper
  #
  # An error which is raised when the authentification process fails
  #
  class AuthentificationError < StandardError
  end

  #
  # An error which is raised when the yaml or p12 key does not contains what expected
  #
  class AuthFileError < StandardError
  end

  #
  # An error which is raised when the http status code of the respose is not within 200..300
  #
  class ResponseStatusError < StandardError
  end

  #
  # An exception which is raised when no calenards are accessible.
  #
  class CalendarAvailabilityError < StandardError
  end

  #
  # An exception which is raised when specified calendar is not available.
  #
  class CalendarAccessibilityError < StandardError
  end

end
