class RaceResult < ActiveRecord::Base
  belongs_to :race
  belongs_to :rider
end
