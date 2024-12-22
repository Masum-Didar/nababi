class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  belongs_to :user

  validates :status, inclusion: { in: %w[pending completed canceled] }
  validates :payment_status, inclusion: { in: %w[unpaid paid failed] }
end
