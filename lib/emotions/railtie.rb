require 'emotions'
require 'rails'

module Emotions
  class Railtie < Rails::Railtie
    initializer 'emotions.active_record' do |app|
      ActiveSupport.on_load :active_record, {}, &Emotions.inject_into_active_record
    end
  end
end
