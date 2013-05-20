require 'emotions'
require 'rails'

module Emotions
  class Railtie < Rails::Railtie
    initializer "emotions.active_record" do |app|
      ActiveSupport.on_load :active_record do
        include Emotions::Emotive
        include Emotions::Emotional
      end
    end
  end
end
