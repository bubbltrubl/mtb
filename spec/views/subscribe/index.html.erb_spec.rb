require 'spec_helper'

describe "subscribe/index.html.erb" do
  it "shows a link to the subscribe page" do
    render
    render.should contain("Inschrijven")
  end
end
