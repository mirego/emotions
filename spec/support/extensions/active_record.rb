class ActiveRecord::Base
  def self.acts_as_emotive
    self.send :include, Emotions::Emotive
  end

  def self.acts_as_emotional
    self.send :include, Emotions::Emotional
  end

  def self.emotive?
    @emotive ||= self.ancestors.include?(Emotions::Emotive)
  end

  def self.emotional?
    @emotional ||= self.ancestors.include?(Emotions::Emotional)
  end
end
