module Api
	class CartsController < ApplicationController
		before_action :get_cart
		before_action :get_user, only: %i[provide]
		before_action :get_cart_item, only: %i[remove_cart]
		before_action :get_product, only: %i[add_cart]
		before_action :authenticate_user!

		def index
			render json: @cart.as_json(include: {cart_items: {include: :product}})
		end

		def add_cart
			if !@product.blank? && !@cart.nil?
				@cart.add_product(@product)
				render json: {data: "Product Added to Cart"}, status: :ok
			else
				render json: "Bad Request", status: :bad_request
			end
		end

		def remove_cart
			if @cart && @cart_item
				@cart.remove_product(@cart_item)
				@message = "Product Removed from Cart"
				render json: @message, status: :ok
			else
				render json: "Bad request", status: :bad_request
			end
		end

		def provide
			unless @cart.cart_items.blank?
				@order = current_user.orders.build(user_name: @username, order_status: :pending)
				if @order.save
					@cart.cart_items.each do |cart_item|
						@order.add_product(cart_item.product)
					end

					@cart.cart_items.each do |cart_item|
						cart_item.destroy
					end
					
					render json: "Provide accepted"
				else
					render json: @order.errors
				end
			else
				render json: "Cart is empty"
			end
		end
		
		private

		def get_cart
			@cart = current_user.cart
		end

		def get_user
			@username = current_user.username
			@user_id = current_user.id
		end

		def get_cart_item
			@cart_item = CartItem.find_by(cart_id: @cart.id, id: params[:id])
		end

		def get_product
			@product = Product.find_by(id: params[:id])
		end
	end
end