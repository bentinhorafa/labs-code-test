class RemoveCashPossibilityFromAccountWithdrawRequests < ActiveRecord::Migration[6.0]
  def change
    remove_column :account_withdraw_requests, :cash_possibility
  end
end
