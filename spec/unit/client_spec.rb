require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'toamqp/client'

describe TOAMQP::Client do
  module ThriftModule
    class Client
      def initialize(protocol); end
    end
  end
  
  describe "#initialize" do
    attr_reader :connection
    before(:each) do
      @connection = flexmock(:connection, 
        :exchange => flexmock(:exchange))
    end
    
    def call
      TOAMQP::Client.new('test', ThriftModule)
    end
    
    it "should obtain a connection from TOAMQP" do
      flexmock(TOAMQP). 
        should_receive(:spawn_connection).once.
        and_return(connection)
        
      call
    end 
    it "should return a thrift client proxy" do
      call.should be_an_instance_of(ThriftModule::Client)
    end
    it "should initialize the client with a Thrift::BinaryProtocol instance" do
      flexmock(ThriftModule::Client).
        should_receive(:new).with(Thrift::BinaryProtocol)
        
      call
    end 
  end
end