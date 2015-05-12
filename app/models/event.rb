class Event < ActiveRecord::Base
  belongs_to :track, foreign_key: 'apple_id'
end
