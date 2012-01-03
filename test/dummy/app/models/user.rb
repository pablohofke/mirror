class User < ActiveRecord::Base
  validates :email,               :presence => true, :uniqueness => true,   :email => true
  validates :email_confirmation,  :presence => true, :confirmation =>true,  :on => :create
  validates :password,            :presence => true, :length => {:within => 6..30}
end
