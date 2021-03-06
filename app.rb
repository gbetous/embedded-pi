require 'eventmachine'
require 'thin'


# This example shows you how to embed Sinatra into your EventMachine
# application. This is very useful if you're application needs some
# sort of API interface and you don't want to use EM's provided
# web-server.

require './site'

module EmbeddedApp

@@count_event = 0

def self.count_event
  @@count_event
end

def self.event_proc
  @event_proc ||= EM.spawn do |param|
    puts "Received notify from #{param}"
    @@count_event = @@count_event +1
  end
end

 
def self.run(opts)

  # Start the reactor
  EM.run do

    # define some defaults for our app
    server  = opts[:server] || 'thin'
    host    = opts[:host]   || '0.0.0.0'
    port    = opts[:port]   || '8181'
    web_app = opts[:app]

    dispatch = Rack::Builder.app do
      map '/' do
        run web_app
      end
    end

    # Start the web server. Note that you are free to run other tasks
    # within your EM instance.
    Rack::Server.start({
      app:    dispatch,
      server: server,
      Host:   host,
      Port:   port
    })

   EM.add_periodic_timer(10) do
      EmbeddedApp.event_proc.notify "periodic"
   end

  end

end

run app: HelloApp.new 
end
