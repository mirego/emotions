module Emotions
  class InvalidEmotion < StandardError
    attr_reader :emotion

    def initialize(emotion)
      @emotion = emotion
    end
  end
end
