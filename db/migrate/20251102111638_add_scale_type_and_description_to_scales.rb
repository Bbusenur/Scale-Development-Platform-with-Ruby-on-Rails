class AddScaleTypeAndDescriptionToScales < ActiveRecord::Migration[8.0]
  def change
    add_column :scales, :scale_type, :string
    add_column :scales, :description, :text
  end
end
