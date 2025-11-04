class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.text :text, null: false
      t.string :question_type, default: 'text'
      t.bigint :survey_id, null: false
      t.integer :order, default: 0

      t.timestamps
    end
    
    add_foreign_key :questions, :surveys
    add_index :questions, :survey_id
  end
end
