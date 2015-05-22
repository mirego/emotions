require 'emotions/version'

require 'ostruct'
require 'active_record'
require 'emotions/errors'
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

  def self.inject_into_active_record
    @inject_into_active_record ||= proc do
      def self.acts_as_emotive
        send :include, Emotions::Emotive
      end

      def self.acts_as_emotional
        send :include, Emotions::Emotional
      end

      def self.acts_as_emotion
        send :include, Emotions::Emotion
      end

      def self.emotional?
        @emotional ||= ancestors.include?(Emotions::Emotional)
      end

      def self.emotive?
        @emotive ||= ancestors.include?(Emotions::Emotive)
      end
    end
  end
end

require 'emotions/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
