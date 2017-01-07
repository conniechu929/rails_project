class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  has_many :comments
end
