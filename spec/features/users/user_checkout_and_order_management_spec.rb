require 'rails_helper'

describe 'User order management' do
  include ActionView::Helpers::NumberHelper
  before do
    user = create(:user)
    @items = create_list(:item, 3)
    cart = Cart.new(nil)
    @items.each { |item| cart.add_item_to_cart(item) }
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit cart_path
    click_button("checkout")
  end
  let(:order) { Order.last }
  describe 'cart checkout' do
    describe 'redirects to orders page' do
      scenario { expect(page).to have_current_path(profile_orders_path) }
    end
    describe 'adds order entry with cart items' do
      scenario { expect(order.items).to eq(@items)}
    end
  end
  describe 'Order index page for user' do
    context 'order details block' do
      subject { page.find("#order-#{order.id}-info") }
      it { is_expected.to have_link "#{order.id}" }
      it { is_expected.to have_content "#{order.created_at.strftime("%m-%d-%Y")}" }
      it { is_expected.to have_content "#{order.updated_at.strftime("%m-%d-%Y")}" }
      it { is_expected.to have_content "#{order.unit_quantity}" }
      it { is_expected.to have_content "#{number_to_currency(order.grand_total)}" }
      it { is_expected.to have_content "pending" }
      it { is_expected.to have_button  "Cancel Order" }
      context 'after cancellation' do
        before do
          user = User.first
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
          click_on "Cancel Order"
        end
        it { is_expected.to have_content "Order status: canceled" }
      end
    end
  end
  describe 'show page for user' do
    before { click_link "#{order.id}" }
    context 'order details block' do
      subject { page.find("#order-#{order.id}-info") }
      it { is_expected.to have_content "Order #{order.id}" }
      it { is_expected.to have_content "Date ordered: #{order.created_at.strftime("%m-%d-%Y")}" }
      it { is_expected.to have_content "Last updated: #{order.updated_at.strftime("%m-%d-%Y")}" }
      it { is_expected.to have_content "Order Size: #{order.unit_quantity} units" }
      it { is_expected.to have_content "Total: #{number_to_currency(order.grand_total)}" }
      it { is_expected.to have_content "Order status: pending" }
      it { is_expected.to have_button  "Cancel Order" }
      context 'after cancellation' do

        before do
          user = User.first
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
          click_on "Cancel Order"
        end
        it { is_expected.to have_content "Order status: canceled" }
      end
    end
  end
end
