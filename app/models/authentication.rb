class Authentication < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  #attr_accessible :user_id
end
