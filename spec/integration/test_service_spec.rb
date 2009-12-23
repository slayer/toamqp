require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

$:.unshift File.join(
  File.dirname(__FILE__), 'protocol/gen-rb')
require 'test'

describe "Server of test service" do
  class TestService < TOAMQP::Service::Base
    serves Test
    exchange :test
    
    def initialize(spool)
      super()
      
      @spool = spool
    end
    
    def announce(msg)
      @spool << msg
    end
    def add(a,b)
      a+b
    end
  end
  
  attr_reader :server, :client, :handler
  attr_reader :received_messages
  before(:each) do
    @received_messages = []
    @handler = TestService.new(received_messages)
    @server = TOAMQP.server(@handler, SpecServer)
    @client = TOAMQP.client('test', Test)
  end
  after(:each) do
    Bunny.run do |conn|
      queue = conn.queue('test')
      queue.purge
    end
  end
  
  context "oneway #announce" do
    it "should transmit message" do
      client.announce('foo')
      server.serve

      received_messages.should include('foo')
    end
    it "should return without waiting for answer (asynchronous operation)" do
      client.announce('foo')
      client.announce('bar')

      # Since we didn't wait for the server, it didn't do the work.
      received_messages.should be_empty
    end
    it "should transmit hundreds of messages" do
      200.times do |i|
        client.announce("message #{i}")
      end
      server.serve
      
      received_messages.should have(200).messages
    end 
    context "server" do
      it "should receive the call" do
        flexmock(handler).
          should_receive(:announce).once
        
        client.announce('foo')
        server.serve
      end 
    end
  end
  context "twoway #add" do
    context "call with (13, 29)" do
      def call
        client.add(13, 29)
      end

      it "should return 42" do
        pending 'simple case'
        call.should == 42
      end 
    end
  end    
end