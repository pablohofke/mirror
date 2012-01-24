class User < ActiveRecord::Base
  attr_accessible :email, :email_confirmation, :password
  attr_accessible :email, :email_confirmation, :password, :rating, :as => :admin
  
  
  has_many :rules
  
  validates :email,               :presence => true, :uniqueness => true, :confirmation =>true,  :email => true
  validates :email_confirmation,  :presence => true, :on => :create
  validates :password,            :presence => true, :length => {:within => 6..30}
end
