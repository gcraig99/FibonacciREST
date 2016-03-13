#!/usr/bin/ruby
require_relative './FibonacciService'

FibonacciService.run! :host => 'localhost', :port => 80, :server => 'webrick'
