require 'atc-tools/flight_plan'
require 'test_helper'

describe ATCTools::FlightPlan do
  
  before do
    @fp = @object = ATCTools::FlightPlan.new \
      callsign:  'QXE1234',
      aircraft:  ATCTools::Aircraft.new,
      rules:     :IFR,
      depart:    ATCTools::Airport.new('KPDX'),
      arrive:    ATCTools::Airport.new(:KLAX),
      alternate: ATCTools::Airport.new(:KSFO),
      cruise:    35000,
      squawk:    '0000',
      route:     'JOGEN Q7 AVE SADDE6',
      remarks:   '/v/'
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
  
  it "has scratchpad" do
    assert_respond_to @fp, :scratchpad
  end
  
  it "can validate IFR cruising altitude based on departure and arrival airport codes" do
    @fp.altitude_valid?.must_equal true
    
    @fp.cruise = 36000
    @fp.altitude_valid?.must_equal false
    
    # Altitudes above FL410
  end
  
  it "can validate IFR west-bound altitudes above FL410" do
    @fp.arrive = ATCTools::Airport.new(:KCLM)
    @fp.cruise = 42000
    @fp.altitude_valid?.must_equal false
    
    @fp.cruise = 43000
    @fp.altitude_valid?.must_equal true
  end
  
  it "can validate IFR altitudes above FL410" do
    @fp.cruise = 41000
    @fp.altitude_valid?.must_equal true
    
    @fp.cruise = 49000
    @fp.altitude_valid?.must_equal true
    
    @fp.cruise = 61000
    @fp.altitude_valid?.must_equal true
    
    @fp.cruise = 43000
    @fp.altitude_valid?.must_equal false
    
    @fp.cruise = 51000
    @fp.altitude_valid?.must_equal false
    
    @fp.cruise = 59000
    @fp.altitude_valid?.must_equal false
  end
  
  # Added due to bug.
  it "reports FL500 as invalid" do
    @fp = @object = ATCTools::FlightPlan.new \
      callsign:  'QXE1234',
      aircraft:  ATCTools::Aircraft.new,
      rules:     :IFR,
      depart:    ATCTools::Airport.new(:KPDX),
      arrive:    ATCTools::Airport.new(:KSEA),
      alternate: ATCTools::Airport.new,
      cruise:    50000,
      squawk:    '0000',
      route:     'DCT SEA',
      remarks:   '/v/'
      
    @fp.altitude_valid?.must_equal false
  end
  
  # Added due to bug.
  it "validates KPDX to KSEA as an even cruise altitude" do
    @fp.arrive = ATCTools::Airport.new(:KSEA)
    
    @fp.cruise = 31000
    @fp.altitude_valid?.must_equal false
    
    @fp.cruise = 30000
    @fp.altitude_valid?.must_equal true
    
    @fp.cruise = 7000
    @fp.altitude_valid?.must_equal false
    
    @fp.cruise = 6000
    @fp.altitude_valid?.must_equal true
  end
  
  it "warns about barometer for FL180, FL190, FL200" do
    skip
  end
  
  it "can validate VFR cruising altitude" do
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
  
  it "can be validated" do
    assert_respond_to @fp, :validate
    
    skip
  end
  
  it "to_s returns the flight plan info" do
    data = @fp.to_s
    
    data.include?(@fp.callsign).must_equal true
    data.include?(@fp.aircraft.to_s).must_equal true
    data.include?(@fp.rules.to_s.upcase).must_equal true
    data.include?(@fp.depart.to_s).must_equal true
    data.include?(@fp.arrive.to_s).must_equal true
    data.include?(@fp.alternate.to_s).must_equal true
    data.include?(@fp.cruise.to_s).must_equal true
    data.include?(@fp.squawk.to_s).must_equal true 
    data.include?(@fp.route).must_equal true
    data.include?(@fp.remarks).must_equal true
    data.include?(@fp.scratchpad).must_equal true
  end
  
  it "can accept a standard cruising altitude" do
    @fp.cruise = 39000
    @fp.cruise.must_equal 39000
  end
  
  it "converts a cruising altitude with the letters 'FL' in the string" do
    @fp.cruise = 'FL370'
    @fp.cruise.must_equal 37000
  end
  
  it "converts a cruising altitude flight level where 'FL' is omitted" do
    @fp.cruise = 350
    @fp.cruise.must_equal 35000
    
    @fp.cruise = '330'
    @fp.cruise.must_equal 33000
  end
  
  # Due to bug.
  it "validates Anchorage PANC" do
    skip
  end
  
  # Due to bug.
  it "validates Honolulu PHNL" do
    skip
  end
  
  # Due to bug.
  it "validates Amsterdam EHAM" do
    skip
  end
  
end