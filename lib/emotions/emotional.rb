module Emotions
  module Emotional
    extend ActiveSupport::Concern

    included do
      has_many :emotions, as: :emotional, class_name: 'Emotions::Emotion', dependent: :destroy

      Emotions.emotions.each do |emotion|
        define_emotion_methods(emotion)
      end
    end

    def _emotions_about(emotive)
      self.emotions.where(emotive_id: emotive.id, emotive_type: emotive.class.name)
    end

    def emotions_about(emotive)
      _emotions_about(emotive).map(&:emotion).map(&:to_sym)
    end

    def express!(emotion, emotive)
      send("#{emotion}_about!", emotive)
    end

    def no_longer_express!(emotion, emotive)
      send("no_longer_#{emotion}_about!", emotive)
    end

    module ClassMethods
      def define_emotion_methods(emotion)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{emotion}_about?(emotive)
            !!#{emotion}_about(emotive).exists?
          end
          alias #{emotion}? #{emotion}_about?
          alias #{emotion}_with? #{emotion}_about?
          alias #{emotion}_over? #{emotion}_about?

          def #{emotion}_about!(emotive)
            emotion = #{emotion}_about(emotive).first_or_initialize
            emotion.tap(&:save!)
          end
          alias #{emotion}_with! #{emotion}_about!
          alias #{emotion}_over! #{emotion}_about!

          def no_longer_#{emotion}_about!(emotive)
            #{emotion}_about(emotive).first.tap(&:destroy)
          end
          alias no_longer_#{emotion}_with! no_longer_#{emotion}_about!
          alias no_longer_#{emotion}_over! no_longer_#{emotion}_about!

          def #{emotion}_about(emotive)
            _emotions_about(emotive).where(emotion: #{emotion.to_s.inspect})
          end
          alias #{emotion}_with #{emotion}_about
          alias #{emotion}_over #{emotion}_about

        RUBY

        instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{emotion}_about(emotive)
            emotional_ids = Emotions::Emotion.where(emotive_id: emotive.id, emotive_type: emotive.class.name, emotional_type: self.name).pluck(:emotional_id)
            self.where(id: emotional_ids)
          end
          alias #{emotion}_with #{emotion}_about
          alias #{emotion}_over #{emotion}_about
        RUBY
      end
    end
  end
end
