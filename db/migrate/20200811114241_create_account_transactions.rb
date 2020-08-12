class CreateAccountTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :account_transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :type, null: false
      t.decimal :amount, null: false
    end
  end
end
