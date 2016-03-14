#!/usr/bin/ruby
require_relative './FibonacciService'
LISTEN_PORT = ARGV[0] || 80

FibonacciService.run! :host => 'localhost', :port => LISTEN_PORT, :server => 'webrick'
