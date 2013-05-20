module Emotions
  module Emotional
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_emotional
        has_many :emotions, as: :emotional, class_name: 'Emotions::Emotion'

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def _emotions_about(emotive)
            self.emotions.where(emotive_id: emotive.id, emotive_type: emotive.class.name)
          end

          def emotions_about(emotive)
            _emotions_about(emotive).map(&:emotion).map(&:to_sym)
          end
        RUBY

        Emotions.emotions.each do |emotion|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{emotion}_about?(emotive)
              #{emotion}_about(emotive).exists?
            end

            def #{emotion}_about?(emotive)
              #{emotion}_about(emotive).exists?
            end

            def #{emotion}_about!(emotive)
              #{emotion}_about(emotive).first_or_create!
            end

            def not_#{emotion}_about!(emotive)
              #{emotion}_about(emotive).destroy
            end

            def #{emotion}_about(emotive)
              _emotions_about(emotive).where(emotion: #{emotion.to_s.inspect})
            end
          RUBY
        end
      end
    end
  end
end
