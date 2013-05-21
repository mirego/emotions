module Emotions
  module Emotive
    extend ActiveSupport::Concern

    included do
      has_many :emotions, as: :emotive, class_name: 'Emotions::Emotion'

      Emotions.emotions.each do |emotion|
        define_emotion_methods(emotion)
      end
    end

    def emotional_about
      self.emotions.includes(:emotional)
    end

    module ClassMethods
      def define_emotion_methods(emotion)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{emotion}_about
            emotional_about.where(emotion: #{emotion.to_s.inspect})
          end
        RUBY
      end
    end
  end
end
