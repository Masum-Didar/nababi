class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :carts, dependent: :destroy


  has_many_attached :images

end
