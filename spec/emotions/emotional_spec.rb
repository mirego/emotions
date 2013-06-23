require 'spec_helper'

describe Emotions::Emotional do
  before do
    emotions :happy, :sad

    run_migration do
      create_table(:users, force: true)
      create_table(:pictures, force: true)
    end

    emotional 'User'
    emotive 'Picture'
  end

  let(:user) { User.create }

  describe :InstanceMethods do
    describe :Aliases do
      subject { user }

      it { should respond_to :happy? }

      it { should respond_to :happy_about? }
      it { should respond_to :happy_with? }
      it { should respond_to :happy_over? }

      it { should respond_to :happy_about! }
      it { should respond_to :happy_with! }
      it { should respond_to :happy_over! }

      it { should respond_to :no_longer_happy_about! }
      it { should respond_to :no_longer_happy_with! }
      it { should respond_to :no_longer_happy_over! }

      it { should respond_to :happy_about }
      it { should respond_to :happy_with }
      it { should respond_to :happy_over }
    end

    describe :emotion_about? do
      before { user.happy_about!(picture) }
      let(:picture) { Picture.create }
      let(:other_picture) { Picture.create }

      it { expect(user.happy_about?(picture)).to be_true }
      it { expect(user.happy_about?(other_picture)).to be_false }
    end

    describe :emotion_about! do
      let(:picture) { Picture.create }

      it { expect(user.happy_about!(picture)).to be_instance_of(Emotions::Emotion) }
      it { expect{ user.happy_about!(picture) }.to change{ Emotions::Emotion.count }.from(0).to(1) }
      it { expect{ user.happy_about!(picture) }.to change{ user.happy_about?(picture) }.from(false).to(true) }
    end

    describe :no_longer_emotion_about! do
      before { user.happy_about!(picture) }
      let(:picture) { Picture.create }

      it { expect(user.no_longer_happy_about!(picture)).to be_instance_of(Emotions::Emotion) }
      it { expect{ user.no_longer_happy_about!(picture) }.to change{ Emotions::Emotion.count }.from(1).to(0) }
      it { expect{ user.no_longer_happy_about!(picture) }.to change{ user.happy_about?(picture) }.from(true).to(false) }
    end
  end

  describe :ClassMethods do
    describe :Aliases do
      subject { user.class }

      it { should respond_to :happy_about }
      it { should respond_to :happy_with }
      it { should respond_to :happy_over }
    end

    describe :emotion_about do
      let(:first_other_user) { User.create }
      let(:second_other_user) { User.create }
      let(:picture) { Picture.create }

      before do
        user.happy_about! picture
        first_other_user.happy_about! picture
      end

      it { expect(User.happy_about(picture).to_a).to eql [user, first_other_user] }
      it { expect(User.happy_about(picture).where('id != ?', first_other_user.id).to_a).to eql [user] }
    end
  end
end
