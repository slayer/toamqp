require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'toamqp/transport'

describe TOAMQP::Transport do
  attr_reader :transport
  before(:each) do
    destination = flexmock(:destination)
    destination.should_ignore_missing
    
    source = flexmock(:source)
    source.should_receive(
      :read => 'buffer').by_default
    
    @transport = TOAMQP::Transport.new(
      :source => source,
      :destination => destination)
  end
  
  describe "#source" do
    it "should not be nil" do
      transport.source.should_not be_nil
    end 
  end
  describe "#destination" do
    it "should not be nil" do
      transport.destination.should_not be_nil
    end 
  end
  
  describe "#write" do
    it "should accept a buffer" do
      transport.write('buffer')
    end 
    it "should delegate writes to the destination" do
      transport.destination.
        should_receive(:write).once
        
      transport.write('test')
    end 
  end
  describe "#flush" do
    it "should delegate flush to the destination" do
      transport.destination.
        should_receive(:flush).once
        
      transport.flush
    end 
  end

  describe "#read" do
    it "should allow reading n bytes" do
      transport.read(10).should == 'buffer'
    end 
  end

  describe "#close" do
    it "should allow calling" do
      transport.close
    end 
  end
end