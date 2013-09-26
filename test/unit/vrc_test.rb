require 'atc-tools/vrc'
require 'test_helper'

describe ATCTools::VRC do
  
  before do
    @vrc = @object = ATCTools::VRC.new
  end
  
  after do
    @vrc = @object = nil
  end
  
  it "extracts data from the flight plan window" do
    skip unless $RUN_VRC_TESTS
  end
  
  it "extracts the selected aircraft callsign" do
    skip unless $RUN_VRC_TESTS
  end
  
  it "can check if an aircraft is currently selected" do
    skip unless $RUN_VRC_TESTS
  end
  
  it "extracts aircraft info" do
    skip unless $RUN_VRC_TESTS
  end
  
  it "extracts text on the command line" do
    skip unless $RUN_VRC_TESTS
  end
  
  it "can enter commands on the command line" do
    skip unless $RUN_VRC_TESTS
  end
  
  it "activates the VRC window" do
    skip unless $RUN_VRC_TESTS
  end
  
  it "activates the terminal window" do
    skip unless $RUN_VRC_TESTS
  end
  
end