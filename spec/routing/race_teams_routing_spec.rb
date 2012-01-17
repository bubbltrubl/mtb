require "spec_helper"

describe RaceTeamsController do
  describe "routing" do

    it "routes to #index" do
      get("/race_teams").should route_to("race_teams#index")
    end

    it "routes to #new" do
      get("/race_teams/new").should route_to("race_teams#new")
    end

    it "routes to #show" do
      get("/race_teams/1").should route_to("race_teams#show", :id => "1")
    end

    it "routes to #edit" do
      get("/race_teams/1/edit").should route_to("race_teams#edit", :id => "1")
    end

    it "routes to #create" do
      post("/race_teams").should route_to("race_teams#create")
    end

    it "routes to #update" do
      put("/race_teams/1").should route_to("race_teams#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/race_teams/1").should route_to("race_teams#destroy", :id => "1")
    end

  end
end
