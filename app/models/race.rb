class Race < ActiveRecord::Base
  belongs_to :category
  belongs_to :race
  has_many :races
  has_many :race_teams
end
