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
      _emotions_about(emotive).pluck(:emotion).map(&:to_sym)
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

            begin
              emotion.tap(&:save!)
            rescue ActiveRecord::RecordInvalid => e
              raise InvalidEmotion.new(e.record)
            end
          end
          alias #{emotion}_with! #{emotion}_about!
          alias #{emotion}_over! #{emotion}_about!

          def no_longer_#{emotion}_about!(emotive)
            #{emotion}_about(emotive).first.tap { |e| e.try(:destroy) }
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
            if emotive.class.emotive?
              emotional_ids = emotive.#{emotion}_about.where(emotional_type: self.name).pluck(:emotional_id)
              where(id: emotional_ids)
            else
              # ActiveRecord 4 supports `.none`, not ActiveRecord 3
              respond_to?(:none) ? none : where('1 = 0')
            end
          end
          alias #{emotion}_with #{emotion}_about
          alias #{emotion}_over #{emotion}_about
        RUBY
      end
    end
  end
end
