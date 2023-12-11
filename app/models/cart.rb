class Cart < ApplicationRecord
    belongs_to :user
    has_many :cart_items
    has_many :products, through: :cart_items

    def add_product(product)
        cart_items.create(product: product)
    end

    def remove_product(cart_item)
        cart_item.destroy
    end
end
