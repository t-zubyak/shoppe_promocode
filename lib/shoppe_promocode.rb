require "shoppe_promocode/engine"
require "shoppe/navigation_manager"

module ShoppePromocode

  #TODO: only prepend a navigational item for Promo Codes rather than re-writing the entire navigation
  Shoppe::NavigationManager.build(:admin_primary) do
    add_item :customers
    add_item :orders
    add_item :products
    add_item :product_categories
    add_item :delivery_services
    add_item :tax_rates
    add_item :promocodes
    add_item :users
    add_item :countries
    add_item :settings
  end

end
