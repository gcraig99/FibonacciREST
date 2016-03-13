require './FibonacciService'
#create the log file for requests and roll it over daily
logger = Logger.new('log/FibonacciService.log', 'daily')
use Rack::CommonLogger, logger
run FibonacciService