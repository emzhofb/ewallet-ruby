class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.references :account, null: false, foreign_key: { to_table: :accounts }
      t.decimal :amount, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
