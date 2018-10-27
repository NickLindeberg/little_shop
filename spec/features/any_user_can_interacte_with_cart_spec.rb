require 'rails_helper'

describe 'any user can interact with a cart' do

  before(:all) do
    @item, @item_2 = create_list(:item, 2)
    visit cart_path
  end

  it 'shows cart with items in it' do
    visit item_path(@item)
    click_on "Add to Cart"
    visit item_path(@item)
    click_on "Add to Cart"

    expect(current_path).to eq(cart_path)
    expect(page).to have_content(@item.name)
    expect(page).to have_content(@item.merchant.name)
    expect(page).to have_content(@item.price)
    within("td.quantity-#{@item.id}")do
      expect(page).to have_content(2)
    end
    within("td.sub-#{@item.id}")do
      expect(page).to have_content(@item.price * 2)
    end
    visit item_path(@item_2)
    click_on "Add to Cart"

    expect(current_path).to eq(cart_path)
    expect(page).to have_content(@item_2.name)
    expect(page).to have_content(@item_2.merchant.name)
    expect(page).to have_content(@item_2.price)
    within("td.quantity-#{@item_2.id}")do
      expect(page).to have_content(1)
    end
    within("td.sub-#{@item_2.id}")do
      expect(page).to have_content(@item_2.price)
    end
    expect(page).to have_content("Cart = 3")

    expect(page).to have_content((@item_2.price) + (@item.price * 2))
    click_on "Empty Cart"

    expect(current_path).to eq(cart_path)
    expect(page).to_not have_content(@item.name)
    expect(page).to_not have_content(@item_2.name)
    expect(page).to have_content("Grand Total: $0.00")

    expect(page).to have_content("Cart = 0")
  end

  it 'lets user remove a particular item from cart' do
    visit item_path(@item)
    click_on "Add to Cart"
    visit item_path(@item_2)
    click_on "Add to Cart"
    visit cart_path
    first(:button, "Remove").click

    expect(page).to_not have_content(@item)
    expect(page).to have_content(@item_2.name)
  end
end
