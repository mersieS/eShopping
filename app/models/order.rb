class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items
    has_many :products, through: :order_items

    enum order_status: %i[pending approved shipped delivered cancelled]

    def add_product(product)
        order_items.create(product: product)
    end

    def get_order_status
        return self.order_status
    end

    def set_order_status
        current_status = self.order_status.to_sym
        next_status_index = (Order.order_statuses[current_status] + 1) % Order.order_statuses.length
        next_status = Order.order_statuses.keys[next_status_index]
        self.update(order_status: next_status)
      end
end
