require 'emotions/version'

require 'active_record'
require 'emotions/emotion'
require 'emotions/emotive'
require 'emotions/emotional'

module Emotions
  def self.configure
    @configuration = OpenStruct.new
    yield(@configuration)
  end

  def self.emotions
    @configuration.emotions ||= []
  end
end

require 'emotions/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
