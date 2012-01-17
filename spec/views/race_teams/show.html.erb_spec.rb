require 'spec_helper'

describe "race_teams/show" do
  before(:each) do
    @race_team = assign(:race_team, stub_model(RaceTeam,
      :race_id => 1,
      :team_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
