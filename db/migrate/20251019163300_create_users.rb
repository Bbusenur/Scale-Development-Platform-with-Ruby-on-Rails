class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :forename
      t.string :surname
      t.string :hashed_password
      t.integer :credit_balance
      t.string :role
      t.string :language

      t.timestamps
    end
  end
end
