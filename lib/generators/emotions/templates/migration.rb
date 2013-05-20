class AddEmotions < ActiveRecord::Migration
  def up
    create_table :emotions do |t|
      # The emotional model
      t.string :emotional_type
      t.integer :emotional_id

      # The emotive model
      t.string :emotive_type
      t.integer :emotive_id

      # The type of emotion
      t.string :emotion

      t.timestamps
    end

    add_index :emotions, [:emotional_type, :emotional_id, :emotional_type, :emotional_id, :emotion], unique: true, name: 'index_emotions_by_emotional_emotive_and_emotion'
    add_index :emotions, [:emotional_type, :emotional_id, :emotional_type, :emotional_id], name: 'index_emotions_by_emotional_and_emotive'
  end

  def down
    drop_table :emotions
  end
end
