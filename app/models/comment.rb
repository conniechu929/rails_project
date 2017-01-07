class Comment < ActiveRecord::Base
  belongs_to :favorite

  validates :content, presence: true
end
