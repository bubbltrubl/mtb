class Rider < ActiveRecord::Base
  belongs_to :cycling_team
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :race_teams
  has_many :race_results

  validates :name, :presence => true
  validates :value, :presence => true  
  validates :cycling_team, :presence => true

  def self.search(params, active)
    if active == true
      sql_string = "riders.active = :active"
    else
      sql_string = "1=1"
    end
    sql_hash = {:active => true}
    if params
      if params[:name]
        sql_string += " AND riders.name LIKE :name"
        sql_hash[:name] = "%#{params[:name]}%"
      end
      if params[:min] and params[:min].try(:to_i)
        sql_string += " AND riders.value >= :min"
        sql_hash[:min] = params[:min].to_i
      end
      if params[:max] and params[:max].try(:to_i)
        sql_string += " AND riders.value <= :max"
        sql_hash[:max] = params[:max].to_i
      end
      if params[:team] and params[:team].try(:to_i)
        sql_string += " AND riders.cycling_team_id = :team"
        sql_hash[:team] = params[:team].to_i
      end
    end
    if sql_hash.length > 1
      self.where(sql_string,sql_hash).order("value DESC").all
    else
      nil
    end
  end
end
