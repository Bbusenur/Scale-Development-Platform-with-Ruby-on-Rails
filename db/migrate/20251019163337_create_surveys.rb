class CreateSurveys < ActiveRecord::Migration[8.0]
  def change
    create_table :surveys do |t|
      t.string :title
      t.string :status
      t.string :distribution_mode
      t.boolean :is_mobile_friendly
      t.references :scale, null: false, foreign_key: true

      t.timestamps
    end
  end
end
