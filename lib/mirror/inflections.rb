module Mirror
  module Inflections
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.irregular 'is', 'are'
    end
  end
end