require 'atc-tools/airport'
require 'test_helper'

describe ATCTools::Airport do
  
  before do
    @airport = @object = ATCTools::Airport.new code: 'KPDX'
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
    # 20 degrees E as of 2013. SEAARTCC SOP
    @airport.variance.must_equal 20.0
  end
  
  it "caches the variance value" do
    skip
  end
  
  it "raises an exception on airport name lookup failure" do
    # Raise an exception that can be used to open the browser to a search
    # engine because the airport may not be listed nationally (AirNav).
    # CYVR - Vancouver International Airport
    Proc.new {
      @airport = ATCTools::Airport.new code: :CYVR
      @airport.discover_name
    }.must_raise ATCTools::NameDiscoveryError
  end
  
  it "caches airport names" do
    skip
  end
  
  it "can find the true heading between itself and another airport" do
    @airport.true_heading_to('KLAX').must_be_close_to 163.2, 0.3
  end
    
  it "can find the magnetic heading between itself and another airport" do
    @airport.magnetic_heading_to(:KLAX).must_be_close_to 163.2 - @airport.variance, 0.3
  end
  
  it "adds 360 to negative headings" do
    # KPDX to KSEA
    @airport.magnetic_heading_to(:KSEA).must_be_close_to 5.9 - @airport.variance + 360.0, 0.3
  end
  
  it "caches heading calculations" do
    skip
  end
  
  it "raises an exception on heading lookup failure" do
    Proc.new {
      @airport.true_heading_to('NOEXIST')
    }.must_raise ATCTools::HeadingDiscoveryError
  end
  
  it "prints its ICAO code on to_s" do
    @airport.to_s.must_equal 'KPDX'
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