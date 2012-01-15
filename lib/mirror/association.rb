# Representa a associação no ActiveModel
module Mirror
  class Association
    include Mirror::Helpers
    
    attr_writer :model
    # Retorna as mensagens do validator
    attr_reader :message
    
    def initialize(model=nil)
      @model= model
    end
    
    # Retorna uma Array com os models associados
    def has_many
      associated_models :has_many
    end
    
    # Retorna Array com os models associados
    def belongs_to
      associated_models :belongs_to
    end
    
    # Verifica se existe has_many association para os models
    # has_many? :model, :outro_model...
    def has_many?(*names)
      has_association? :has_many, *names
    end
    
    # Verifica se existe belongs_to association para os models
    # belongs_to? :model, :outro_model...
    def belongs_to?(*names)
      has_association? :belongs_to, *names
    end
    
    protected
    
    # Retorna uma array com os model associdos em função do tipo
    def associated_models(association_type)
      @model.reflect_on_all_associations(association_type).map(&:name)
    end
    
    # Verifica se existe o tipo de associação
    def has_association?(association, *names)
      if (wrong_associations = names - send(association)).present?
        false & @message= "#{@model.to_s} has no #{association.to_s} #{inflect("association",wrong_associations.size)} with #{sentence(wrong_associations)}"
      else
        true
      end
    end
    
  end
end