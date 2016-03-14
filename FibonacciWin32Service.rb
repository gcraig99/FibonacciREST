require 'win32/daemon'
require './FibonacciService'
include Win32
LISTEN_PORT = ARGV[0] || 80

class FibonacciServiceDaemon < Daemon
  def service_main
	#Start the FibonacciService on port 80 using the WEBrick server
	FibonacciService.run! :host => 'localhost', :port => LISTEN_PORT, :server => 'webrick'
	while running?
	sleep 100
	end
  end
  
  def service_stop
   
    exit!
  end
  
end

FibonacciServiceDaemon.mainloop