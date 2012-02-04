class Race < ActiveRecord::Base
  belongs_to :category
  belongs_to :race
  has_many :races
  has_many :race_teams

  validates :name, :presence => true
  validates :previous_winner, :presence => true
  validates :category, :presence => true

  def can_make_race_team?
    date >= Time.zone.now
  end

  def possible_to_make_race_team(races)
    races.index { |other_race| other_race.id != self.id and other_race.overlaps_with(self) and other_race.starts_before(self)}.nil?
  end

  def starts_before(other_race)
    other_race.date > self.date
  end

  def overlaps_with(other_race)
    (Race.date_between(other_race.date,date,end_date) or Race.date_between(other_race.end_date,date,end_date)) 
  end

  def find_earlier_overlapping_race
    Race.where("date <= :begin_date AND end_date > :begin_date AND end_date < :end_date",{:begin_date => date, :end_date => end_date}).first
  end
  
  def self.all_except_stages
    return Race.where(race_id: nil).all
  end

  def self.first_possible_race
   self.where("date > :now", {:now => Time.zone.now}).order("date ASC").first
  end

  private
  def self.date_between(other_date,begin_date,end_date)
    (other_date >= begin_date and other_date <= end_date)
  end
end
