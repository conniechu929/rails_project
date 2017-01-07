class Place < ActiveRecord::Base
  has_many :favorites
  has_many :comments, through: :favorites

  validates :business, :address, :city, :state, presence: true
end
