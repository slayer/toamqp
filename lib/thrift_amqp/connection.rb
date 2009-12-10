# Connection to the AMQP server and a factory for all the transports you 
# might eventually need. 
#
class Thrift::AMQP::Connection
  # Accessor for the backend connection
  #
  attr_reader :connection
   
  def initialize(credentials = {})
    @credentials = credentials.inject({}) { 
      |hash, (k,v)| 
      hash[k.to_sym] = v
      hash
    }
    @credentials[:pass] = @credentials.delete(:password) || ''
  end
  
  # Internal command to create and start the connection. 
  #
  def start
    @connection = Bunny.new(@credentials)
    @connection.start    
    
    self
  end

  # Use Thrift::AMQP.start instead.
  #
  def self.start(credentials = {})
    new(credentials).start
  end
  
  # Creates a service.
  #
  def service(name, twoway=false)
    Thrift::AMQP::Service.new(connection, name, twoway)
  end
end