#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'test_types'

module Test
  class Client
    include ::Thrift::Client

    def announce(message)
      send_announce(message)
    end

    def send_announce(message)
      send_message('announce', Announce_args, :message => message)
    end
    def add(a, b)
      send_add(a, b)
      return recv_add()
    end

    def send_add(a, b)
      send_message('add', Add_args, :a => a, :b => b)
    end

    def recv_add()
      result = receive_message(Add_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'add failed: unknown result')
    end

  end

  class Processor
    include ::Thrift::Processor

    def process_announce(seqid, iprot, oprot)
      args = read_args(iprot, Announce_args)
      @handler.announce(args.message)
      return
    end

    def process_add(seqid, iprot, oprot)
      args = read_args(iprot, Add_args)
      result = Add_result.new()
      result.success = @handler.add(args.a, args.b)
      write_result(result, oprot, 'add', seqid)
    end

  end

  # HELPER FUNCTIONS AND STRUCTURES

  class Announce_args
    include ::Thrift::Struct
    MESSAGE = 1

    ::Thrift::Struct.field_accessor self, :message
    FIELDS = {
      MESSAGE => {:type => ::Thrift::Types::STRING, :name => 'message'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

  end

  class Announce_result
    include ::Thrift::Struct

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

  end

  class Add_args
    include ::Thrift::Struct
    A = 1
    B = 2

    ::Thrift::Struct.field_accessor self, :a, :b
    FIELDS = {
      A => {:type => ::Thrift::Types::I32, :name => 'a'},
      B => {:type => ::Thrift::Types::I32, :name => 'b'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

  end

  class Add_result
    include ::Thrift::Struct
    SUCCESS = 0

    ::Thrift::Struct.field_accessor self, :success
    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::I32, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

  end

end
