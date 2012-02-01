class Rider < ActiveRecord::Base
  belongs_to :cycling_team
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :race_teams

  validates :name, :presence => true
  validates :value, :presence => true  
  validates :cycling_team, :presence => true

  def self.search(params)
    if params and params[:name]
      self.where("riders.name LIKE :name", {:name => "%#{params[:name]}%"}).joins(:cycling_team).order("value DESC").all
    else
      nil
    end
  end
end
