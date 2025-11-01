class CreateAnalyses < ActiveRecord::Migration[8.0]
  def change
    create_table :analyses do |t|
      t.references :survey, null: false, foreign_key: true
      t.string :analysis_type, null: false
      t.string :status, null: false, default: "Queued"
      t.jsonb :result

      t.timestamps
    end

    add_index :analyses, :status
  end
end


