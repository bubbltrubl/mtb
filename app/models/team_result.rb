class TeamResult < ActiveRecord::Base
  belongs_to :team
  belongs_to :result
  belongs_to :race
end
