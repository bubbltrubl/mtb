require 'spec_helper'

describe "race_teams/new" do
  before(:each) do
    assign(:race_team, stub_model(RaceTeam,
      :race_id => 1,
      :team_id => 1
    ).as_new_record)
  end

  it "renders new race_team form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => race_teams_path, :method => "post" do
      assert_select "input#race_team_race_id", :name => "race_team[race_id]"
      assert_select "input#race_team_team_id", :name => "race_team[team_id]"
    end
  end
end
