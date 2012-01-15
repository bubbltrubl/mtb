require 'spec_helper'

describe "riders/edit" do
  before(:each) do
    @rider = assign(:rider, stub_model(Rider,
      :name => "MyString",
      :value => 1,
      :points => 1,
      :boolean => "",
      :integer => ""
    ))
  end

  it "renders the edit rider form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => riders_path(@rider), :method => "post" do
      assert_select "input#rider_name", :name => "rider[name]"
      assert_select "input#rider_value", :name => "rider[value]"
      assert_select "input#rider_points", :name => "rider[points]"
      assert_select "input#rider_boolean", :name => "rider[boolean]"
      assert_select "input#rider_integer", :name => "rider[integer]"
    end
  end
end
