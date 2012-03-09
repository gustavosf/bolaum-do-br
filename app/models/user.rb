class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :name, :photo, :password

  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :photo
  validates_presence_of :password, :on => :create

  validates_uniqueness_of :email
end