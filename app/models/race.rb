class Race < ActiveRecord::Base
  belongs_to :category
  belongs_to :race
  has_many :races
  has_many :race_teams

  def possible_to_make_race_team(races)
    races.index { |other_race| other_race.id != self.id and other_race.overlaps_with(self) and other_race.starts_before(self)}.nil?
  end

  def starts_before(other_race)
    other_race.date > self.date
  end

  def overlaps_with(other_race)
    (Race.date_between(other_race.date,date,end_date) or Race.date_between(other_race.end_date,date,end_date)) 
  end
 
  private
  def self.date_between(other_date,begin_date,end_date)
    (other_date >= begin_date and other_date <= end_date)
  end
end
