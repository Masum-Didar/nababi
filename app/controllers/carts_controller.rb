class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.carts.includes(:product)
  end
  def show
    @cart_items = current_user.carts.includes(:product)
  end

  def create
    # Add product to cart
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    cart_item = current_user.carts.find_or_initialize_by(product: product)
    cart_item.quantity += quantity
    if cart_item.save
      redirect_to carts_path, notice: "#{product.name} added to your cart."
    else
      redirect_to product_path(product), alert: "Failed to add #{product.name} to your cart."
    end
  end

  def update
    cart_item = current_user.carts.find(params[:id])
    if cart_item.update(cart_params)
      redirect_to carts_path, notice: 'Cart updated successfully!'
    else
      redirect_to carts_path, alert: 'Failed to update cart.'
    end
  end

  def destroy
    cart_item = current_user.carts.find(params[:id])
    cart_item.destroy
    redirect_to carts_path, notice: 'Item removed from cart.'
  end

  private

  def cart_params
    params.require(:cart).permit(:product_id, :quantity)
  end
end
