require File.dirname(__FILE__) + '/../spec_helper'

describe CyclingTeamsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => CyclingTeam.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    CyclingTeam.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    CyclingTeam.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(cycling_team_url(assigns[:cycling_team]))
  end

  it "edit action should render edit template" do
    get :edit, :id => CyclingTeam.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    CyclingTeam.any_instance.stubs(:valid?).returns(false)
    put :update, :id => CyclingTeam.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    CyclingTeam.any_instance.stubs(:valid?).returns(true)
    put :update, :id => CyclingTeam.first
    response.should redirect_to(cycling_team_url(assigns[:cycling_team]))
  end

  it "destroy action should destroy model and redirect to index action" do
    cycling_team = CyclingTeam.first
    delete :destroy, :id => cycling_team
    response.should redirect_to(cycling_teams_url)
    CyclingTeam.exists?(cycling_team.id).should be_false
  end
end
