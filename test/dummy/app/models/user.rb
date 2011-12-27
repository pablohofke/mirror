class User < ActiveRecord::Base
  validates :email,     :presence => true, :uniqueness => true, :email => true
  validates :password,  :presence => true, :length => {:within => 6..30}
end
