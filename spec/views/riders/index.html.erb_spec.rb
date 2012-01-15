require 'spec_helper'

describe "riders/index" do
  before(:each) do
    assign(:riders, [
      stub_model(Rider,
        :name => "Name",
        :value => 1,
        :points => 1,
        :boolean => "",
        :integer => ""
      ),
      stub_model(Rider,
        :name => "Name",
        :value => 1,
        :points => 1,
        :boolean => "",
        :integer => ""
      )
    ])
  end

  it "renders a list of riders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
