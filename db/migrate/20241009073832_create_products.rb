class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      # t.text :image_urls # Store URLs as a JSON string, but without a default value

      t.timestamps
    end
  end
end
