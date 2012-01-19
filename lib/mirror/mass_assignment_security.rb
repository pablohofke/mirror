module Mirror
  class MassAssignmentSecurity
    
    include Mirror::Helpers
    
    attr_writer :model
    # Retorna as mensagens do validator
    attr_reader :message
    
    def initialize(model=nil)
      @model= model
    end
    
    def accessible_attributes?(*args)
      access_to_attributes? :accessible_attributes, *args
    end
    
    def protected_attributes?(*args)
      access_to_attributes? :protected_attributes, *args
    end
    
    private
    
    def access_to_attributes?(type,*args)
      options=args.extract_options!
      role=options[:as] || :default
      if (wrond_attributes = args-Array(@model.send(type, role)).map(&:to_sym)).any?
        @message="#{sentence(wrond_attributes)} #{inflect("is",wrond_attributes.size)} not "
        @message << if type == :accessible_attributes then "accessible" else "protected" end
        @message << " for #{role}" if role != :default
        false
      else
        true
      end
    end
    
    
  end
end