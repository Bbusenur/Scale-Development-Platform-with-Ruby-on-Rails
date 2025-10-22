class CreateCreditTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_transactions do |t|
      t.integer :cost
      t.string :activity_type
      t.datetime :transaction_date
      t.integer :reference_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
