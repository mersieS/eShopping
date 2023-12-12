class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items
    has_many :products, through: :order_items

    enum order_status: %i[pending approved shipped delivered cancelled]

    def add_product(product)
        order_items.create(product: product)
    end
end
