class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :key_handle, limit: 255
      t.string :public_key, limit: 255
      t.string :certificate
      t.integer :counter
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
