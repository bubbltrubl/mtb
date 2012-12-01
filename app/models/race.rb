class Race < ActiveRecord::Base
  SUBSCRIBE_UNTIL = 6 #ID of the race

  belongs_to :period
  belongs_to :category
  belongs_to :race
  has_many :races
  has_many :race_teams
  has_many :race_results
  has_many :team_results

  validates :name, :presence => true
  validates :previous_winner, :presence => true
  validates :category, :presence => true

  def display_name
    unless race.nil?
      return "#{race.name} > #{name}"
    end
    return name
  end

  def can_make_race_team?
    date >= Time.zone.now
  end

  def possible_to_make_race_team(races, race_teams)
    return false unless can_make_race_team?
    has_no_overlapping_race = races.index { |other_race| other_race.id != self.id and other_race.overlaps_with(self) and other_race.starts_before(self) }.nil?
    if has_no_overlapping_race
      return true
    else
      return (race_teams.empty? or race_teams.first.race_id == self.id)
    end
  end
  
  def possible_to_make_race_team_without_date_check(races, race_teams)
    has_no_overlapping_race = races.index { |other_race| other_race.id != self.id and other_race.overlaps_with(self) and other_race.starts_before(self) }.nil?
    if has_no_overlapping_race
      return true
    else
      return (race_teams.empty? or race_teams.first.race_id == self.id)
    end
  end

  def starts_before(other_race)
    other_race.date > self.date
  end

  def overlaps_with(other_race)
    (Race.date_between(other_race.date,date,end_date) or Race.date_between(other_race.end_date,date,end_date)) 
  end
  
  def latest_stage
    return nil if (is_tour == false or races.empty?)
    return races.select {|stage| stage.results_ready }.sort{ |x,y| y.date <=> x.date }.first
  end  

  def get_previous_race
    # get previous race
    previous_race = Race.where("date < :date AND race_id IS :race_id",{:date => date, :race_id => nil}).order("date DESC").first
    return nil if previous_race.nil?
    # check if results ready
    return previous_race if previous_race.results_ready
    # if not check if is tour and if it has a stage with results ready
    if previous_race.is_tour
      finished_stages = Race.where("race_id = :race_id AND results_ready = :rr",{:race_id => previous_race.id, :rr => true})
      return previous_race unless finished_stages.empty?
    end
    # else no previous race
    return nil
  end

  def get_next_race
    # get next race
    next_race = Race.where("date > :date AND race_id IS :race_id",{:date => date, :race_id => nil}).order("date ASC").first
    return nil if next_race.nil?
    # check if results ready
    return next_race if next_race.results_ready
    # if not check if is tour and if it has a stage with results ready
    if next_race.is_tour
      finished_stages = Race.where("race_id = :race_id AND results_ready = :rr",{:race_id => next_race.id, :rr => true})
      return next_race unless finished_stages.empty?
    end
    # else no previous race
    return nil
  end
  
  def self.all_except_stages
    return Race.where(race_id: nil).all
  end
  
  def self.editable_races(races, race_teams)
    editable_races = races.reject { |race| not race.possible_to_make_race_team(races, race_teams) }
  end

  def self.first_possible_race
   self.where("date > :now", {:now => Time.zone.now}).order("date ASC").first
  end
  
  def self.can_subscribe?
    self.where(id: SUBSCRIBE_UNTIL).first.date >= Time.zone.now
  end
  
  def self.latest_available_result
    race = self.where(results_ready: true).order("races.end_date DESC").first
  end

  private
  def self.date_between(other_date,begin_date,end_date)
    (other_date >= begin_date and other_date <= end_date)
  end
end
