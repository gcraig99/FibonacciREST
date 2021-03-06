# FibonacciREST
A RESTFUL service that returns the request number of numbers from the Fibonacci Sequence

## Known Limitations
* When running as a service on Windows or a Daemon on Linux if there's a conflict on port 80 there's no error thrown by the WEBRick server. Port can be changed from default of 80 by passing in the port to listen on to the installer script
* Linux Installation only tested on Ubuntu derivatives - should work on any system that uses init scripts. Installation will not work on systemd systems out of the box.
* Linux systems running SELinux may require additional configuration to allow the server to accept connections

## Installation Requirements
* Ruby version >= 1.9.3
* RubyGems - https://rubygems.org/pages/download
* Bundler Gem version > 1.5.0
	* To install - gem install bundler
	
 _Requires Ruby DevKit before installing Gems in step 2_ 
* Windows - Follow instructions at http://github.com/oneclick/rubyinstaller/wiki/Development-Kit and make sure to match the architecture of DevKit to the architecture of the installed Ruby (i.e. both 32bit or both 64bit)
* Linux - Install ruby-dev package


## Preperation Instructions
1. Download the source 
	* git clone https://github.com/gcraig99/FibonacciREST.git <TargetDir> 
	* OR Download and unpack the zip file https://github.com/gcraig99/FibonacciREST/archive/master.zip
2. From the target directory where you cloned or unpacked the zip:
	1. bundler install
	2. Verify there were no errors installing required Gems with bundler
	
	
## Installation Instructions
* Windows or Linux Interactively  
	* From a command or terminal window in the directory where you cloned/unpacked the source to: 
	* rackup -p *__ListenPort__*
* Windows as a Service  
	_NOTE Listens on port 80 by default. Replace port 80 with your preferred port in FibonacciWin32Service.rb_
	* From a command window in the directory where you cloned/unpacked the source to: 
	* ruby WindowsServiceInstaller.rb install [Listen Port]
* Linux, as a Daemon
	* From a terminal in the directory where you cloned/unpacked the source to: 
	* ruby LinuxDaemonInstaller.rb install [Listen Port]
	
## Testing the Service
* Open your browser or use a REST client to connect to http://localhost:*__ListenPort__*/5
* You should see [0,1,1,2,3] returned
 

## TODOs
* Improve logging in installation scripts
* Add additional error handling in installation scripts
* Come up with a way to detect port conflicts or switch to a diffent server than WEBrick

