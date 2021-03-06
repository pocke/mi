if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'

  Coveralls.wear!
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter

  SimpleCov.add_filter '/spec/'
  SimpleCov.add_filter '/vendor/bundle/'

  SimpleCov.start
end
