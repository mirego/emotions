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
      let(:relation) do
        double.tap { |double| double.stub(:count).and_return(42) }
      end

      before do
        Picture.any_instance.stub(:happy_about).and_return(relation)
        picture.update_emotion_counter(:happy)
      end

      it { expect(picture.reload.happy_emotions_count).to eql 42 }
    end
  end
end
