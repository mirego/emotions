module Emotions
  module Emotive
    extend ActiveSupport::Concern

    included do
      has_many :emotions, as: :emotive, class_name: '::Emotion', dependent: :destroy

      Emotions.emotions.each do |emotion|
        define_emotion_methods(emotion)
      end
    end

    # @private
    def update_emotion_counter(emotion)
      attribute = "#{emotion}_emotions_count"

      if respond_to?(attribute)
        update_attribute(attribute, send("#{emotion}_about").count)
      end
    end

    # @private
    module ClassMethods
      def define_emotion_methods(emotion)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{emotion}_about
            emotions.where(emotion: #{emotion.to_s.inspect})
          end
          alias #{emotion}_with #{emotion}_about
          alias #{emotion}_over #{emotion}_about
        RUBY
      end
    end
  end
end
