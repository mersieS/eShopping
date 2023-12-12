module Api    
    class OrdersController < ApplicationController
        before_action :
        before_action :authenticate_user!

        def index
            @order = Order.order(created_at: :asc)
            render json: @order.as_json(include: {order_items: {include: :product}})
        end

        def set_order_status
            if @order && !(@order.order_status == :delivered)
                @order.order_status += 1
                render json: @order.as_json(include: {order_status: {include: :order_status}})
                if @order.order.status == :approved
                    @order.order_items.each do |order_item|
                        @product = order_item.product
					    @product.update(quantity: (@product.quantity - 1))
                    end
                end
            elsif @order.order_status == :delivered
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
    end
end