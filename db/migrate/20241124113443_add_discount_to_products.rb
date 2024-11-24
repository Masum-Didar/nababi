class AddDiscountToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :discount, :decimal
  end
end
