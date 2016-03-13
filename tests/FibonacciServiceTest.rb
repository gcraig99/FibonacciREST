ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../FibonacciService'
require 'minitest/reporters'

class FibonacciServiceTest < Minitest::Test
  include Rack::Test::Methods

  def app
    FibonacciService
  end

  #Becasue all requests to the Query String route are in turn passed into the path route by testing the query string route
  #we are inherently testing the path route as well

  #Test that requesting 5 items from the sequence always returns a 200 status and the correct values for the sequence
  def test_qs_route_with_valid_param
    get '/FibonacciSequence?seqCount=5'
    assert last_response.ok?
    assert_equal '[0,1,1,2,3]', last_response.body
  end

  #Test that if we pass in a non numeric value for the number of items from the sequence we get a 400 status and
  # our error message is returned to the client
  def test_qs_route_with_non_numeric_param
    get '/FibonacciSequence?seqCount=test'
    assert last_response.status == 400
    assert last_response.body == 'The requested number of items from the sequence must be a positive number.'
  end

  #Test that if we pass in a negative number we get a 400 status and our error message is returned to the client
  def test_qs_route_with_negative_param
    get '/FibonacciSequence?seqCount=-20'
    assert last_response.status == 400
    assert last_response.body == 'The requested number of items from the sequence must be a positive number.'
  end

  #Test that if we pass in a zero, we get a 200 status and an empty json array
  #important because since we seed the first 2 values in the array and someone removes the slice 0 or 1 will return 2 items
  def test_qs_route_with_zero_param
    get '/FibonacciSequence?seqCount=0'
    assert last_response.ok?
    assert last_response.body == '[]'
  end

  #Test that if we pass in a one, we get a 200 status and only the first item from the sequence is returned
  #important because since we seed the first 2 values in the array and someone removes the slice 0 or 1 will return 2 items
  def test_qs_route_with_one_param
    get '/FibonacciSequence?seqCount=1'
    assert last_response.ok?
    assert last_response.body == '[0]'
  end

end