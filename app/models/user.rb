class User < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude
  has_secure_password
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end
