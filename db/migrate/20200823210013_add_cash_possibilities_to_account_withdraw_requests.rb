class AddCashPossibilitiesToAccountWithdrawRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :account_withdraw_requests, :cash_possibilities, :text, null: false
  end
end
