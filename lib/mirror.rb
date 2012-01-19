module Mirror
  require 'mirror/assertions'
  
  autoload :Validator, 'mirror/validator'
  autoload :Assertions, 'mirror/assertions'
  autoload :Helpers, 'mirror/helpers'
  autoload :Association, 'mirror/association'
  autoload :MassAssignmentSecurity, 'mirror/mass_assignment_security'
  autoload :Inflections, 'mirror/inflections'
end
