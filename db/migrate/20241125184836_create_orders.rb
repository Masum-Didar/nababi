class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, null: false, precision: 10, scale: 2
      t.string :tracking_number
      t.string :status, null: false, default: "pending"
      t.string :payment_status, null: false, default: "unpaid"
      t.string :shipping_address
      t.string :payment_method
      t.datetime :order_date, null: false
      t.datetime :delivery_date

      t.timestamps
    end
  end
end
