# Representa o validator
module Mirror
  class Validator
    attr_accessor :model
    
    def initialize(model=nil)
      @model= model
    end
    
    # Verifica a existencia do validator.kind para o attribute
    # has_kind? :email, :presence
    # has_kind? :email, [:presence,:uniqueness]
    def has_kind?(attribute,kinds)
      kinds_to_check,result=[],[]
      kinds_to_check << kinds
      kinds_to_check.flatten!
      kinds_to_check.each{|k| result << check_kind(attribute,k)}
      !result.include?(false)
    end
    
    # Verifica existencias das options para o attribute
    # has_options?(:attribute)
    # has_options?(:attribute, :kind => :value)
    # has_options?(:attribute, :kind => :value, :options =>{...})
    # has_options?(:attribute, :options => {...})
    def has_options?(attribute,args={})
      kind=args[:kind] if args[:kind]
      options_to_check=normalize_options args[:options] if args[:options]
      if args=={}
        !options(attribute).empty?
      elsif kind && !options_to_check
        !options(attribute,kind).empty?
      elsif kind && options_to_check
        (options_to_check.to_a - options(attribute,kind).to_a).empty?
      elsif !kind && options_to_check
        (options_to_check.to_a - options(attribute).to_a).empty?
      end  
     end
    
    # Retorna as options do validator ou do attribute
    # options :email, :presence
    # options :email
    def options(attribute, kind=nil)
      validators=@model.validators_on(attribute)
      options={}
      if kind
        validators.find{|v| v.class.kind == kind}.instance_eval "@options"
      else
        validators.map(&:options).each{|o| options=options.merge o}
        options
      end
    end
    
    protected
    
    # Reorganiza a hash options quando ela apresenta diferença na escrita e o que é passado
    def normalize_options(options)
      options.symbolize_keys!
      if range = (options.delete(:in) || options.delete(:within))
        raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
        options[:minimum], options[:maximum] = range.begin, range.end
        options[:maximum] -= 1 if range.exclude_end?
      end
      options
    end
    
    # Verifica se existe o validator kind para o attribute 
    def check_kind(attribute,kind)
      kind_validators=[]
      if (class_validators=@model.validators_on(attribute).map(&:class))
        class_validators.each{|v| kind_validators << v.kind}
        kind_validators.include?(kind)
      else
        false
      end
    end
    
  end
end