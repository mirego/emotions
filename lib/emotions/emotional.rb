module Emotions
  module Emotional
    extend ActiveSupport::Concern

    included do
      has_many :emotions, as: :emotional, class_name: 'Emotions::Emotion', dependent: :destroy

      Emotions.emotions.each do |emotion|
        define_emotion_methods(emotion)
      end
    end

    # @private
    def _emotions_about(emotive)
      self.emotions.where(emotive_id: emotive.id, emotive_type: emotive.class.name)
    end

    # Return all emotions expressed by the emotional record
    # towards another emotive record
    #
    # @example
    #   user = User.first
    #   picture = Picture.first
    #   user.express! :happy, picture
    #   user.emotions_about(picture)
    #   # => [:happy]
    def emotions_about(emotive)
      _emotions_about(emotive).pluck(:emotion).map(&:to_sym)
    end

    # Express an emotion towards another record
    #
    # @example
    #   user = User.first
    #   picture = Picture.first
    #   user.express! :happy, picture
    def express!(emotion, emotive)
      emotion = _emotions_about(emotive).where(emotion: emotion).first_or_initialize

      begin
        emotion.tap(&:save!)
      rescue ActiveRecord::RecordInvalid => e
        raise InvalidEmotion.new(e.record)
      end
    end

    # No longer express an emotion towards another record
    #
    # @example
    #   user = User.first
    #   picture = Picture.first
    #   user.no_longer_express! :happy, picture
    def no_longer_express!(emotion, emotive)
      _emotions_about(emotive).where(emotion: emotion).first.tap { |e| e.try(:destroy) }
    end

    module ClassMethods
      # Return an `ActiveRecord::Relation` containing the emotional records
      # that expressed a specific emotion towards an emotive record
      #
      # @example
      #   user = User.first
      #   picture = Picture.first
      #   user.express! :happy, picture
      #   User.emotional_about(:happy, picture)
      #   # => #<ActiveRecord::Relation [#<User id=1>]>
      def emotional_about(emotion, emotive)
        if emotive.class.emotive?
          emotional_ids = emotive.emotions.where(emotion: emotion).where(emotional_type: self.name).pluck(:emotional_id)
          where(id: emotional_ids)
        else
          # ActiveRecord 4 supports `.none`, not ActiveRecord 3
          respond_to?(:none) ? none : where('1 = 0')
        end
      end

      def define_emotion_methods(emotion)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{emotion}_about?(emotive)
            !!#{emotion}_about(emotive).exists?
          end

          def #{emotion}_about!(emotive)
            express! #{emotion.inspect}, emotive
          end

          def no_longer_#{emotion}_about!(emotive)
            no_longer_express! #{emotion.inspect}, emotive
          end

          def #{emotion}_about(emotive)
            _emotions_about(emotive).where(emotion: #{emotion.to_s.inspect})
          end

          alias #{emotion}? #{emotion}_about?
          alias #{emotion}_with? #{emotion}_about?
          alias #{emotion}_over? #{emotion}_about?

          alias #{emotion}_with! #{emotion}_about!
          alias #{emotion}_over! #{emotion}_about!

          alias no_longer_#{emotion}_with! no_longer_#{emotion}_about!
          alias no_longer_#{emotion}_over! no_longer_#{emotion}_about!

          alias #{emotion}_with #{emotion}_about
          alias #{emotion}_over #{emotion}_about
        RUBY

        instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{emotion}_about(emotive)
            emotional_about(#{emotion.inspect}, emotive)
          end

          alias #{emotion}_with #{emotion}_about
          alias #{emotion}_over #{emotion}_about
        RUBY
      end
    end
  end
end
