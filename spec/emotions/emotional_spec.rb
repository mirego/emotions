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

    describe :emotions_about do
      let(:picture) { Picture.create }

      context 'for user with emotions' do
        before do
          user.happy_about! picture
          user.sad_about! picture
        end

        it { expect(user.emotions_about(picture)).to eql [:happy, :sad] }
      end

      context 'for user without emotions' do
        it { expect(user.emotions_about(picture)).to be_empty }
      end

      context 'for invalid emotive' do
        it { expect(user.emotions_about(user)).to be_empty }
        it { expect{ user.emotions_about(user) }.to_not raise_error }
      end
    end

    describe :express! do
      let(:picture) { Picture.create }

      context 'with valid emotive and emotion' do
        it { expect{ user.express! :happy, picture }.to change{ Emotions::Emotion.count }.from(0).to(1) }
        it { expect{ user.express! :happy, picture }.to change{ user.happy_about? picture }.from(false).to(true) }
      end

      context 'with invalid emotive' do
        it { expect{ user.express! :happy, user }.to raise_error(Emotions::InvalidEmotion) }
      end

      context 'with invalid emotion' do
        it { expect{ user.express! :mad, picture }.to raise_error(NoMethodError) }
      end
    end

    describe :no_longer_express! do
      let(:picture) { Picture.create }
      before { user.happy_about!(picture) }

      context 'with valid emotive and emotion' do
        it { expect{ user.no_longer_express! :happy, picture }.to change{ Emotions::Emotion.count }.from(1).to(0) }
        it { expect{ user.no_longer_express! :happy, picture }.to change{ user.happy_about? picture }.from(true).to(false) }
      end

      context 'with invalid emotive' do
        it { expect{ user.no_longer_express! :happy, user }.to_not raise_error }
      end

      context 'with invalid emotion' do
        it { expect{ user.no_longer_express! :mad, user }.to raise_error(NoMethodError) }
      end
    end

    describe :DynamicMethods do
      describe :emotion_about? do
        before { user.happy_about!(picture) }
        let(:picture) { Picture.create }
        let(:other_picture) { Picture.create }

        context 'with valid emotive' do
          it { expect(user.happy_about? picture).to be_true }
          it { expect(user.happy_about? other_picture).to be_false }
        end

        context 'with invalid emotive' do
          it { expect{ user.happy_about? user }.to_not raise_error }
        end
      end

      describe :emotion_about! do
        let(:picture) { Picture.create }

        context 'with valid emotive' do
          it { expect(user.happy_about! picture).to be_instance_of(Emotions::Emotion) }
          it { expect{ user.happy_about! picture }.to change{ Emotions::Emotion.count }.from(0).to(1) }
          it { expect{ user.happy_about! picture }.to change{ user.happy_about? picture }.from(false).to(true) }
        end

        context 'with invalid emotive' do
          it { expect{ user.happy_about! user }.to raise_error(Emotions::InvalidEmotion) }
        end
      end

      describe :no_longer_emotion_about! do
        before { user.happy_about!(picture) }
        let(:picture) { Picture.create }

        context 'with valid emotive' do
          it { expect(user.no_longer_happy_about! picture).to be_instance_of(Emotions::Emotion) }
          it { expect{ user.no_longer_happy_about! picture }.to change{ Emotions::Emotion.count }.from(1).to(0) }
          it { expect{ user.no_longer_happy_about! picture }.to change{ user.happy_about? picture }.from(true).to(false) }
        end

        context 'with invalid emotive' do
          it { expect(user.no_longer_happy_about! user).to be_nil }
          it { expect{ user.no_longer_happy_about! user }.to_not raise_error }
        end
      end
    end
  end

  describe :ClassMethods do
    describe :Aliases do
      subject { user.class }

      it { should respond_to :happy_about }
      it { should respond_to :happy_with }
      it { should respond_to :happy_over }
    end

    describe :DynamicMethods do
      describe :emotion_about do
        let(:first_other_user) { User.create }
        let(:second_other_user) { User.create }
        let(:picture) { Picture.create }

        before do
          user.happy_about! picture
          first_other_user.happy_about! picture
        end

        context 'with valid emotive' do
          it { expect(User.happy_about(picture).to_a).to eql [user, first_other_user] }
          it { expect(User.happy_about(picture).where('id != ?', first_other_user.id).to_a).to eql [user] }
        end

        context 'with invalid emotive' do
          it { expect(User.happy_about(user).to_a).to be_empty }
          it { expect{ User.happy_about(user).to_a }.to_not raise_error }
        end
      end
    end
  end
end
