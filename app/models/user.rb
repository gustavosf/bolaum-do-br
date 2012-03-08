class User < ActiveRecord::Base
  has_secure_password

  #attr_accessible :email, :password_digest, :name, :last_login

  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :password, :on => :create

  validates_uniqueness_of :email
end