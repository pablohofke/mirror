module Mirror
  module Helpers
    
    def sentence(array)
      array.to_sentence :last_word_connector => " and "
    end
    
    def inflect(word,count)
      if count>1
        word.pluralize
      else
        word
      end
    end
    
  end
end