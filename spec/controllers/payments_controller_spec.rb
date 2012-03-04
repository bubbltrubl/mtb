require 'spec_helper'

describe PaymentsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'set_paid'" do
    it "returns http success" do
      get 'set_paid'
      response.should be_success
    end
  end

  describe "GET 'set_unpaid'" do
    it "returns http success" do
      get 'set_unpaid'
      response.should be_success
    end
  end

end
