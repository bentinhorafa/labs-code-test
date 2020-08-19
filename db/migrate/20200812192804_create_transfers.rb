class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.integer :origin_id, null: false
      t.integer :destiny_id, null: false
      t.decimal :amount, null: false

      t.timestamps
    end

    add_index :transfers, :origin_id, name: :index_transfers_on_origin_id, using: :btree
    add_index :transfers, :destiny_id, name: :index_transfers_on_destiny_id, using: :btree
  end
end
