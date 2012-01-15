require "spec_helper"

describe RidersController do
  describe "routing" do

    it "routes to #index" do
      get("/riders").should route_to("riders#index")
    end

    it "routes to #new" do
      get("/riders/new").should route_to("riders#new")
    end

    it "routes to #show" do
      get("/riders/1").should route_to("riders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/riders/1/edit").should route_to("riders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/riders").should route_to("riders#create")
    end

    it "routes to #update" do
      put("/riders/1").should route_to("riders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/riders/1").should route_to("riders#destroy", :id => "1")
    end

  end
end
