module Emotions
  module Emotive
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_emotive
        has_many :emotions, as: :emotive, class_name: 'Emotions::Emotion'

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def emotional_about
            self.emotions.includes(:emotional)
          end
        RUBY

        Emotions.emotions.each do |emotion|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{emotion}_about
              emotional_about.where(emotion: #{emotion.to_s.inspect})
            end
          RUBY
        end
      end
    end
  end
end
