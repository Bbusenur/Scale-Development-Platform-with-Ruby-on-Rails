class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.string :participant_id
      t.jsonb :raw_data
      t.references :survey, null: false, foreign_key: true

      t.timestamps
    end
  end
end
