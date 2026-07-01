class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :rfc, null: false
      t.string :password_digest, null: false
      t.string :role, default: "user"
      t.references :creator, foreign_key: { to_table: :users, on_delete: :nullify }, null: true
      t.string :address
      t.string :phone
      t.string :website

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :rfc, unique: true
  end
end
