module Mirror
  module Helpers
    
    include Mirror::Inflections
    
    # Gera uma sentença com uma array
    def sentence(array)
      array.to_sentence :last_word_connector => " and "
    end
    
    # Flexiona a palara para plurar ou singular
    def inflect(word,count)
      if count>1
        word.pluralize
      else
        word
      end
    end
    
  end
end