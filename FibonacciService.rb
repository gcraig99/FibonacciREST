#sinatra GEM provides the routing capabilities of this REST service
require 'sinatra/base'


class FibonacciService < Sinatra::Base
  require 'json'
  require 'rack/logger'
  require 'rack/commonlogger'


  # Set up the environment
  configure :production, :development do
    enable :logging, :dump_errors
    Dir.mkdir 'log' unless File.exists? 'log'
    logger = Logger.new(File.join(File.dirname(__FILE__), 'log/FibonacciService.log'), 'daily')
    use Rack::CommonLogger, logger
  end

  # Route handler for requests where the requested number of sequence items is in the query string.
  # This handler will in turn pass it to the route handler for requests with the parameter in the path
  get('/FibonacciSequence') {
    unless params['seqCount']
      halt 400, "Required parameter seqCount was not set. Please set seqCount to the number of items from the Fibonacci Sequence you would like returned. \
  This can be done by path (/FibonacciSequence/5) or by query string /FibonacciSequence?seqCount=5"
    end
    status, headers, body = call! env.merge('PATH_INFO' => "/FibonacciSequence/#{params['seqCount']}")
    [status, headers, body]
  }
  # Route handler for requests where the requested number of sequence items is in the URI path
  get('/FibonacciSequence/:seqCount') {
    begin
      fib_sequence = get_fibonacci_sequence(params['seqCount'])
    rescue ArgumentError => err
      #handle ArgumentErrors from get_fibonacci_sequence and pass the message back to the client with a HTTP Status code of 400
      halt 400, err.message
    end
    # serialize the array to json and return it to the client
    JSON.generate(fib_sequence)
  }

  # Calculates the given number of items from the Fibonacci Sequence
  def get_fibonacci_sequence(count)
    $i = 0
    # make sure we were passed in a number by converting it to an integer and then comparing the string value of the resulting
    # object to the original as to_i will output 0 if it can't convert to an integer
    # if it's not a number we'll raise an ArgumentError
    i_count = count.to_i
    if i_count.to_s != count || i_count < 0
      raise(ArgumentError, 'The requested number of items from the sequence must be a positive number.')
    end

     # create a new array to hold the calculated values and seed it with the first 2 numbers of the sequence to use in the calculations
    fib_sequence = Array.new
    fib_sequence.push 0
    fib_sequence.push 1
    $i+=2

    while $i <= i_count
          fib_sequence.push fib_sequence[-2] + fib_sequence[-1]
      $i+=1
    end
      # because we seed the array with the first 2 values of the sequence, we use slice to make sure we don't return too many items
      # in the case where they request 0 or 1 items
      fib_sequence.slice(0, i_count)
  end

  not_found do
    [404, 'Maybe you are looking for /FibonacciSequence']
  end
  
 
end
