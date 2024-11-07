class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.string :currency, default: "USD"
    
      t.timestamps
    end
  end
end
