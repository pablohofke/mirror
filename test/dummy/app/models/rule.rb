class Rule < ActiveRecord::Base
  attr_protected :name
  
  belongs_to :user
end
