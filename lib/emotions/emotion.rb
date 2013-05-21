module Emotions
  class Emotion < ActiveRecord::Base
    self.table_name = 'emotions'

    # Validations
    validates :emotional, presence: true
    validates :emotive, presence: true
    validates_each :emotion do |record, attr, value|
      record.errors.add attr, 'invalid' unless Emotions.emotions.include?(value.try(:to_sym))
    end

    # Associations
    belongs_to :emotional, polymorphic: true
    belongs_to :emotive, polymorphic: true

    # Callbacks
    after_create :update_emotion_counter
    after_destroy :update_emotion_counter

  protected

    def update_emotion_counter
      self.emotive.update_emotion_counter(self.emotion)
    end
  end
end
