require 'atc-tools/aircraft'
require 'test_helper'

describe ATCTools::Aircraft do
  
  before do
    # ------------------------------
    # TODO: Use a real code from VRC
    # ------------------------------
    @aircraft = @object = ATCTools::Aircraft.new 'A321/Q',
      info: 'A321 - AIRBUS INDUSTRIES (International) A-321 - Engines/Class: 2J/L - C/D Rates: 3500/3500 - SRS Category III'
  end
  
  after do
    @aircraft = @object = nil
  end
  
  it "exposes the raw data (typically from VRC) used to create the object" do
    assert_respond_to @aircraft, :raw
  end
  
  it "has a model" do
    assert_respond_to @aircraft, :model
  end
  
  it "has an aircraft code -- the text displayed on the radar scope" do
    assert_respond_to @aircraft, :code
    @aircraft.code.must_equal 'A321'
  end
  
  it "has equipment code" do
    assert_respond_to @aircraft, :equipment
    @aircraft.equipment.must_equal 'Q'
  end
  
  it "exposes the full info string from VRC's .acinfo command" do
    assert_respond_to @aircraft, :info
  end
  
  it "can validate the aircraft's equipment." do
    skip
  end
  
  it "caches aircraft info" do
    skip
  end
  
  it "can parse 'A/C Type' field and search cache before pulling data from VRC." do
    skip
  end
  
  it "to_s returns the raw variable" do
    @aircraft.to_s.must_equal @aircraft.raw
  end
  
end