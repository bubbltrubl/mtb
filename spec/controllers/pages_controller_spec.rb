require 'spec_helper'

describe PagesController do

  describe "GET 'reglement'" do
    it "returns http success" do
      get 'reglement'
      response.should be_success
    end
  end

end
