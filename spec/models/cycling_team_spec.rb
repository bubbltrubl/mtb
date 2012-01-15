require File.dirname(__FILE__) + '/../spec_helper'

describe CyclingTeam do
  it "should be valid" do
    CyclingTeam.new.should be_valid
  end
end
