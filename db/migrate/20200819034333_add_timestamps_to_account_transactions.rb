class AddTimestampsToAccountTransactions < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :account_transactions
  end
end
