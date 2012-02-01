class Category < ActiveRecord::Base
  has_many :races
  validates :name, :presence => true
  validates :nr_of_riders, :presence => true 
  validates :points, :presence => true
end
