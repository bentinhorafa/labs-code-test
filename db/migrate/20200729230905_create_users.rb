class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :full_name, null: false, limit: 200
      t.string :document, null: false, limit: 11
      t.string :address, null: false, limit: 200
      t.date :birthday, null: false
      t.string :gender, null: false, limit: 1
      t.string :password, null: false, limit: 8
      t.string :token, null: false
    end

    add_index :users, :document, unique: true
    add_index :users, :token, unique: true
  end
end
