# FibonacciREST
Fibonacci REST Service

##Requirements
* Ruby version > 2.0
* Ruby Gems - https://rubygems.org/pages/download
* Bundler Gem version > 1.5.0
	* To install - gem install bundler
* _Windows note_ - Requires Ruby DevKit before installing Gems- Follow instructions at http://github.com/oneclick/rubyinstaller/wiki/Development-Kit and make sure 
						   to match the architecture of DevKit to the architecture of the installed Ruby (i.e. both 32bit or both 64bit)


## Installation Instructions
1. Download the source 
	* git clone https://github.com/gcraig99/FibonacciREST.git <TargetDir> 
	* OR Download and unpack the zip file https://github.com/gcraig99/FibonacciREST/archive/master.zip
2. From the target directory where you cloned or unpacked the zip:
	1. bundler install
	2. Verify there were no errors installing required Gems with bundler
	
	
## Running the Fibonacci REST Service
* Windows or Linux Interactively  
	* From a command or terminal window in the directory where you cloned/unpacked the source to: rackup -p *__ListenPort__*
* Windows as a Service  
	_NOTE Listens on port 80 by default. Replace port 80 with your preferred port in FibonacciWin32Service.rb_
	* From a command window in the directory where you cloned/unpacked the source to: ruby FibonacciWindowsSeriveInstaller.rb
* Linux, as a Daemon
	* TODO Instructions
