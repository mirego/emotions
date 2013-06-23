require 'spec_helper'

describe Emotions::Emotive do
  before do
    emotions :happy, :sad

    run_migration do
      create_table(:users, force: true)
      create_table(:pictures, force: true)
    end

    emotional 'User'
    emotive 'Picture'
  end

  let(:picture) { Picture.create }

  describe :InstanceMethods do
    describe :Aliases do
      subject { picture }

      it { should respond_to :happy_about }
      it { should respond_to :happy_with }
      it { should respond_to :happy_over }
    end

    describe :emotion_about do
      let(:user1) { User.create }
      let(:user2) { User.create }
      let(:user3) { User.create }

      before do
        user1.happy_about! picture
        user3.happy_about! picture
      end

      it { expect(picture.happy_about.map(&:emotional)).to eql [user1, user3] }
    end
  end
end
