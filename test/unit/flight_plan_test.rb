require 'atc-tools/flight_plan'
require 'test_helper'

describe FlightPlan do
  
  before do
    @fp = @object = FlightPlan.new
  end
  
  after do
    @fp = @object = nil
  end
  
  it "has an aircraft callsign" do
    assert_respond_to @fp, :callsign
  end
  
  it "has an aircraft type" do
    assert_respond_to @fp, :aircraft
  end
  
  it "has flight rules" do
    assert_respond_to @fp, :rules
  end
  
  it "has a departure airport" do
    assert_respond_to @fp, :depart
  end
  
  it "has an arrival airport" do
    assert_respond_to @fp, :arrive
  end
  
  it "has an alternate airport" do
    assert_respond_to @fp, :alternate
  end
  
  it "has a cruise altitude" do
    assert_respond_to @fp, :cruise
  end
  
  it "has a squawk code" do
    assert_respond_to @fp, :squawk
  end
  
  it "has a route" do
    assert_respond_to @fp, :route
  end
  
  it "has remarks" do
    assert_respond_to @fp, :remarks
  end
  
  it "can validate flight level based on departure and arrival airport codes" do
    skip
  end
  
  it "can validate departure procedures" do
    # This may be a job for a Route class.
    skip
  end
  
  it "can find the name for a VOR" do
    # This may be a job for a Route class.
    skip
  end
  
end