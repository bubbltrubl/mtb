require 'spec_helper'

describe "race_teams/index" do
  before(:each) do
    assign(:race_teams, [
      stub_model(RaceTeam,
        :race_id => 1,
        :team_id => 1
      ),
      stub_model(RaceTeam,
        :race_id => 1,
        :team_id => 1
      )
    ])
  end

  it "renders a list of race_teams" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
