class RaceTeam < ActiveRecord::Base
  MAXIMUM_SIZE = 10

  belongs_to :race
  belongs_to :team
  belongs_to :user
  has_and_belongs_to_many :riders

  validates :riders, :length => {:is => MAXIMUM_SIZE}
end
