class CreateCollaborators < ActiveRecord::Migration[8.1]
  def change
    create_table :collaborators do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :rfc, null: false
      t.text :fiscal_address, null: false
      t.string :curp, null: false
      t.string :social_security_number, null: false
      t.date :start_date, null: false
      t.string :contract_type, null: false
      t.string :department, null: false
      t.string :position, null: false
      t.decimal :daily_salary, precision: 10, scale: 2, null: false
      t.decimal :salary, precision: 10, scale: 2, null: false
      t.string :entity_key, null: false
      t.string :state, null: false
      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
