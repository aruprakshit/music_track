class Track < ActiveRecord::Base
  # self.primary_key = 'apple_id'
  has_many :events, foreign_key: "apple_id"
end
