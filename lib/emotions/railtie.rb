require 'emotions'
require 'rails'

module Emotions
  class Railtie < Rails::Railtie
    initializer "emotions.active_record" do |app|
      ActiveSupport.on_load :active_record do
        def self.acts_as_emotive
          self.send :include, Emotions::Emotive
        end

        def self.acts_as_emotional
          self.send :include, Emotions::Emotional
        end
      end
    end
  end
end
