class AddTimestampsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :accounts
  end
end
