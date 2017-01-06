class Place < ActiveRecord::Base
  belongs_to :user

  validates :business, :address, :city, :state, presence: true
end
