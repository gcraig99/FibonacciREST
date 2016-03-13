source 'https://rubygems.org'

if Gem::Version.new(Bundler::VERSION) < Gem::Version.new('1.5.0')
  abort "FibonacciService requires Bundler 1.5.0 or higher (you're using #{Bundler::VERSION}).\nPlease update with 'gem update bundler'."
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters', '>= 0.5.0'
  if RUBY_PLATFORM =~ /(win32|w32)/
    gem 'win32console', '1.3.0'
  end

end

group :service do
  gem 'sinatra', '>= 1.4.7'
  gem 'test-unit', '>= 3.0.8'
  gem 'rack', '>= 1.6.4'
  gem 'rack-test', '>= 0.6.3'
  gem 'json', '>= 1.8.3'
end


