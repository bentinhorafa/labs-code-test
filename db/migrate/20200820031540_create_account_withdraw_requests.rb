class CreateAccountWithdrawRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :account_withdraw_requests do |t|
      t.decimal :amount, null: false
      t.string :cash_possibility
      t.references :account, null: false, foreign_key: true
      t.references :account_transaction, foreign_key: true

      t.timestamps
    end
  end
end
