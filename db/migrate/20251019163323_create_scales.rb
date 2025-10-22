class CreateScales < ActiveRecord::Migration[8.0]
  def change
    create_table :scales do |t|
      t.string :unique_scale_id
      t.string :title
      t.string :version
      t.datetime :last_validated_at
      t.boolean :is_public
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
