class RenameAccountTransactionTypeToTransactionType < ActiveRecord::Migration[6.0]
  def change
    rename_column :account_transactions, :type, :transaction_type
  end
end
