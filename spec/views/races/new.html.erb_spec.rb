require 'spec_helper'

describe "races/new" do
  before(:each) do
    assign(:race, stub_model(Race,
      :name => "MyString",
      :is_tour => false,
      :previous_winner => "MyString",
      :race_id => 1,
      :category_id => 1,
      :results_ready => false,
      :team_time_trial => false
    ).as_new_record)
  end

  it "renders new race form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => races_path, :method => "post" do
      assert_select "input#race_name", :name => "race[name]"
      assert_select "input#race_is_tour", :name => "race[is_tour]"
      assert_select "input#race_previous_winner", :name => "race[previous_winner]"
      assert_select "input#race_race_id", :name => "race[race_id]"
      assert_select "input#race_category_id", :name => "race[category_id]"
      assert_select "input#race_results_ready", :name => "race[results_ready]"
      assert_select "input#race_team_time_trial", :name => "race[team_time_trial]"
    end
  end
end
