require 'spec_helper'

describe "races/index" do
  before(:each) do
    assign(:races, [
      stub_model(Race,
        :name => "Name",
        :is_tour => false,
        :previous_winner => "Previous Winner",
        :race_id => 1,
        :category_id => 1,
        :results_ready => false,
        :team_time_trial => false
      ),
      stub_model(Race,
        :name => "Name",
        :is_tour => false,
        :previous_winner => "Previous Winner",
        :race_id => 1,
        :category_id => 1,
        :results_ready => false,
        :team_time_trial => false
      )
    ])
  end

  it "renders a list of races" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Previous Winner".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
