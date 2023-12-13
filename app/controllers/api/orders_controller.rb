module Api    
    class OrdersController < ApplicationController
        before_action :get_order, only: %i[show set_order_status cancel_order]
        before_action :get_order_status, only: %i[set_order_status cancel_order]
        before_action :authenticate_user!

        def index
            order = Order.order(created_at: :asc)
            render json: order.as_json(include: {order_items: {include: :product}})
        end

        def show
            unless @order.blank?
                render json: @order.as_json(include: {order_items: {include: :product}})
            else
                render json: "Bad request", status: :bad_request
            end
        end

        def get_by_username
            @user = User.find_by(username: params[:user_name])
            @orders = @user.orders
            unless @orders.blank?
                render json: @orders
            else
                render json: "Bad request", status: :bad_request
            end
        end

        def set_order_status
            if @order && (@order_status != "delivered")
                if (@order_status == "pending")
                    @control = true
                    @order.order_items.each do |order_item|
                        @product = order_item.product
                        if (@product.quantity > 0)
					        @product.update(quantity: (@product.quantity - 1))
                        else
                            render json: "Product quantitiy not enough"
                            @control = false
                            break
                        end
                    end
                    if @control
                        @order.set_order_status
                        render json: @order
                    end
                else
                    @order.set_order_status
                    render json: @order
                end
            elsif (@order_status == "delivered")
                render json: "Order already delivered"
            else
                render json: "Bad request", status: :bad_request
            end
        end

        def cancel_order
            if @order
                if (@order_status == "pending") || (@order_status == "approved")
                    @order.update(order_status: :cancelled)
                    if(@order_status == "approved")
                        @order.order_items.each do |order_item|
                            @product = order_item.product
                            @product.update(quantity: (@product.quantity + 1))
                        end
                    end
                    render json: @order
                elsif (@order_status == "shipped") || (@order_status == "delivered")
                    render json: "Order can't canceled"
                else
                    render json: "Order already canceled"
                end
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
                if @order
                    @order_status = @order.get_order_status
                end
            end
    end
end