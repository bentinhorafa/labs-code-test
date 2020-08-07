class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :branch, null: false, limit: 4
      t.string :account_number, null: false, limit: 5
      t.decimal :limit, null: false, default: 0.0
      t.timestamp :last_limit_update, null: false
      t.decimal :balance
      t.references :user, null: false, foreign_key: true
    end

    add_index :accounts, [:branch, :account_number], unique: true
  end
end
