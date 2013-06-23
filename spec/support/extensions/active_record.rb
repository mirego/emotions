class ActiveRecord::Base
  def self.acts_as_emotive
    self.send :include, Emotions::Emotive
  end

  def self.acts_as_emotional
    self.send :include, Emotions::Emotional
  end
end
