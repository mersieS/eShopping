module Api    
    class OrdersController < ApplicationController
        before_action :get_order, only: %i[set_order_status]
        before_action :get_order_status, only: %i[set_order_status]
        before_action :authenticate_user!

        def index
            @order = Order.order(created_at: :asc)
            render json: @order.as_json(include: {order_items: {include: :product}})
        end

        def set_order_status
            if @order && !(@order_status == "delivered")
                @order.set_order_status
                if (@order_status == "approved")
                    @order.order_items.each do |order_item|
                        @product = order_item.product
					    @product.update(quantity: (@product.quantity - 1))
                    end
                end
                render json: @order
            elsif (@order_status == "delivered")
                render json: "Order already delivered."
            else
                render json: "Bad request", status: :bad_request
            end
        end

        private
            def order_params
                params permit(:username)
            end

            def get_order
                @order = Order.find_by(id: params[:id])
            end

            def get_order_status
                @order_status = @order.get_order_status
            end
    end
end