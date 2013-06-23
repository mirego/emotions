require 'spec_helper'

describe Emotions::Emotive do
  before do
    emotions :happy, :sad

    run_migration do
      create_table(:users, force: true)
      create_table(:pictures, force: true) do |t|
        t.integer :happy_emotions_count, default: 0
        t.integer :sad_emotions_count, default: 0
      end
    end

    emotional 'User'
    emotive 'Picture'
  end

  let(:picture) { Picture.create }

  describe :InstanceMethods do
    describe :update_emotion_counter do
      let(:user1) { User.create }
      let(:user2) { User.create }
      let(:user3) { User.create }

      before do
        user1.happy_about! picture
        user3.happy_about! picture
        picture.reload
      end

      it { expect(picture.happy_emotions_count).to eql 2 }
    end
  end
end
