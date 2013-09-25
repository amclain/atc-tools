require 'vrc-fpv/airport'
require 'test_helper'

describe Airport do
  
  before do
    @airport = @object = Airport.new code: 'KPDX'
  end
  
  after do
    @airport = @object = nil
  end
  
  it "has a name" do
    assert_respond_to @airport, :name
  end
  
  it "has an ICAO code" do
    assert_respond_to @airport, :code
    @airport.code.must_equal 'KPDX'
  end
  
  it "has a magnetic variance" do
    assert_respond_to @airport, :variance
  end
  
  it "can find its name based on ICAO code" do
    @airport.discover_name
    @airport.name.must_equal 'Portland International Airport'
  end
  
  it "can find its magnetic variance based on ICAO code" do
    # 17 degrees E as of 2013.
    @airport.variance.must_equal 17.0
  end
  
  it "caches the variance value" do
    skip
  end
  
  it "launches the web browser on arrival airport name lookup failure" do
    # Open the browser to Google because the airport may not be listed
    # nationally (AirNav).
    # YVR - Vancouver International Airport
    
    # Replace this test with RAISES EXCEPTION.
    skip
  end
  
  it "raises an exception on airport name lookup failure" do
    skip
  end
  
  it "caches airport names" do
    skip
  end
  
  it "can find the true heading between itself and another airport" do
    @airport.true_heading_to('KLAX').must_equal 163.2
  end
    
  it "can find the magnetic heading between itself and another airport" do
    @airport.magnetic_heading_to(:KLAX).must_equal 146.2
  end
  
  it "caches heading calculations" do
    skip
  end
  
  it "launches the web browser on heading lookup failure" do
    # Open the browser to a heading calculator website for
    # manual calculation.
    
    # Replace with RAISES EXCEPTION.
    skip
  end
  
  it "raises an exception on heading lookup failure" do
    Proc.new {
      @airport.true_heading_to('NOEXIST')
    }.must_raise HeadingError
  end
  
  it "prints its ICAO code on to_s" do
    skip
  end
  
  it "can convert true heading to magnetic" do
    heading = 163.2
    @airport.variance = 17.0
    @airport.true_to_magnetic(heading).must_equal 146.2
  end
  
  it "can convert magnetic heading to true" do
    heading = 146.2
    @airport.variance = 17.0
    @airport.magnetic_to_true(heading).must_equal 163.2
  end
  
end