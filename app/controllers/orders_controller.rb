class OrdersController < ApplicationController
  def index
  end

  def create
    new_order = Order.create(user: current_user)
    new_order.add_cart_items(cart.items)
    if new_order.id
      # TODO: Didn't test this because the cart in the test was spoofed.
      # Need to figure out how to incorporate that.
      session[:cart] = nil
    end
    redirect_to profile_orders_path
  end
end
