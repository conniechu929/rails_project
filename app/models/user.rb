class User < ActiveRecord::Base
  # attr_accessible :address, :latitude, :longitude
  has_secure_password
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :name, :email, :presence => true, length: { maximum: 20 }
  validates :email, uniqueness: { case_sensitive: false }, :format => { :with => email_regex }
  validates :password, :confirmation => true , presence: true, length: { minimum: 8 }
end
