class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :user_name
      t.integer :order_status

      t.timestamps
    end
  end
end
