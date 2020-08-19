class AddTransferToAccountTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :account_transactions, :transfer, foreign_key: true
  end
end
