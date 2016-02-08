#ShoppePromocode

ShoppePromocode is a plugin that adds basic Coupon/Promocode functionality to a Shoppe e-commerce platform.

The overall idea of the project is to be able to apply a coupon code, that would reduce the total amount in customer's cart (current version does not give the ability to apply coupons to specific products, only to the overall amount).

Coupons can either have a percentage value associated or a flat rate.

## Usage

### Shoppe side
Add this gem to your project:

Gemfile
```
gem 'shoppe_promocode', '~> 0.0.2'
```
```
bundle install
```

Run migration (plugin adds a shoppe_promocodes table)
```
rake db:migrate
```

After restarting your server you should be able to visit /shoppe/promocodes to see the admin interface for managing promocodes.

### Client side

On the client side, all you need to do is add a form and a custom controller action that would add a promocode to your cart, as if it was an actual item but with a negative amount (You might need to tweak your cart rendering in case if some of the values aren't present on promocodes).

Custom action route (routes.rb)
```
post "/apply_coupon", to: "orders#add_coupon", as: "apply_coupon"
```

Form (HAML)
```haml
= form_tag apply_coupon_path, class: "form-inline" do
  = text_field_tag :promocode, '', class: 'form-control', placeholder: "Enter your coupon code"
  = submit_tag 'APPLY COUPON',  class: "btn btn-primary", data: {disable_with: 'APPLYING'}
```

Custom controller action
```ruby
def add_coupon
  if Shoppe::Promocode.valid_coupon?(params[:promocode])
    @promocode = Shoppe::Promocode.where(code: params[:promocode]).first
    #the following can be refactored and placed into a method on the Promocode object. Will be added to the next release
    coupon_value = if @promocode.discount_type == "percentage"
                    current_order.total_before_tax * @promocode.discount_value / 100
                   else
                    @promocode.discount_value
                   end
    c = current_order.order_items.new(ordered_item_id: @promocode.id, ordered_item_type: "Shoppe::Promocode", quantity: 1, unit_price: -coupon_value, unit_cost_price: 0, tax_amount: 0, tax_rate: 0, weight: 0)
    c.save(validate: false) #shoppe platform has a validation to make sure that items in the cart are actual products. This is a hack-ish way to jump over that. If you have a better suggestion, please let me know
    current_order.reload
    redirect_to cart_path and return
  else
    redirect_to cart_path, alert: "Invalid coupon" and return
  end
  redirect_to cart_path, alert: "Something is not quite right! Coupon code cannot be added to cart." and return
end
```

Should be good to go. Please let me know if you have any problems. I'll be more than happy to help.

Thank you for being interested in using this gem.

#TODO
- Tests
- Discounts per item
