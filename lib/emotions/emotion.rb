module Emotions
  class Emotion < ActiveRecord::Base
    self.table_name = 'emotions'

    # Validations
    validates :emotional, presence: true
    validates :emotive, presence: true

    # Custom validations
    validate :ensure_valid_emotion_name
    validate { ensure_valid_associated_record :emotional }
    validate { ensure_valid_associated_record :emotive }

    # Associations
    belongs_to :emotional, polymorphic: true
    belongs_to :emotive, polymorphic: true

    # Callbacks
    after_create :update_emotion_counter
    after_destroy :update_emotion_counter

  protected

    # Update the `<emotion>_emotions_counter` for the emotive record
    def update_emotion_counter
      self.emotive.update_emotion_counter(self.emotion)
      self.emotional.update_emotion_counter(self.emotion)
    end

    # Make sure we're using an allowed emotion name
    def ensure_valid_emotion_name
      unless Emotions.emotions.include?(self.emotion.try(:to_sym))
        errors.add :emotion, I18n.t(:invalid, scope: [:errors, :messages])
      end
    end

    # Make sure that both emotive and emotional records are actually able to
    # express and/or receive emotions
    def ensure_valid_associated_record(association)
      value = send(association)
      predicate = :"#{association}?"

      if !value.class.respond_to?(predicate) || !value.class.send(predicate)
        errors.add association, I18n.t(:invalid, scope: [:errors, :messages])
      end
    end
  end
end
