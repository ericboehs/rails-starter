class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :password_digest
      t.boolean :admin, default: false

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
