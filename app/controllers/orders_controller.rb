class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]
  before_action :set_product, only: [:create]

  def index
    @orders = Order.all
  end

  def show; end

  def new
    @order = Order.new
  end

  def create
    # For a single product order directly from the product page
    if params[:product_id].present?
      create_single_product_order
      # For a regular order with multiple items
    elsif params[:order_items].present?
      create_multiple_items_order
    else
      redirect_to new_order_path, alert: 'Order must include at least one product.'
    end
  end

  def edit; end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully deleted.'
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_product
    @product = Product.find_by(id: params[:product_id]) if params[:product_id].present?
  end

  def order_params
    params.require(:order).permit(
      :status,
      :payment_status,
      :shipping_address,
      :payment_method,
      :order_date,
      :delivery_date,
      :tracking_number,         # New: Tracking number for the order
      :total_price,             # New: Total price of the order
      :user_id,                 # New: User who placed the order
      order_items_attributes: [:product_id, :quantity] # Allow nested order items
    )
  end

  def add_order_items(order)
    params[:order_items].each do |item|
      product = Product.find_by(id: item[:product_id])
      next unless product # Skip if the product doesn't exist

      order.order_items.create(
        product: product,
        quantity: item[:quantity],
        price: product.price
      )
    end
  end

  # Handle single product orders from product page
  def create_single_product_order
    @order = Order.new(order_params)
    @order.user = current_user
    @order.total_price = @product.price * params[:quantity].to_i # Calculate total price for the order

    if @order.save
      @order.order_items.create(product: @product, quantity: params[:quantity], price: @product.price)
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Handle multiple items in the order
  def create_multiple_items_order
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.save
      add_order_items(@order)
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
end
