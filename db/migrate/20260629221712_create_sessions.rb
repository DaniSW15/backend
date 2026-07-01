class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :token, null: false
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :sessions, :token, unique: true
  end
end
