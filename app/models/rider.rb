class Rider < ActiveRecord::Base
  belongs_to :cycling_team
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :race_teams

  validates :name, :presence => true
  validates :value, :presence => true  
  validates :cycling_team, :presence => true

  def self.search(params)
    if params and params[:name] and params[:max] and params[:max].try(:to_i)
      self.where("riders.name LIKE :name AND riders.value <= :max", {:name => "%#{params[:name]}%", :max => params[:max].to_i}).joins(:cycling_team).order("value DESC").all
    elsif params and params[:name]
      self.where("riders.name LIKE :name", {:name => "%#{params[:name]}%"}).joins(:cycling_team).order("value DESC").all
    else
      nil
    end
  end
end
