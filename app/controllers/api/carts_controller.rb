module Api
	class CartsController < ApplicationController
		require_relative '../../security_operation/role_module.rb'
		before_action :get_cart
		before_action :get_user, only: %i[provide]
		before_action :get_cart_item, only: %i[remove_cart]
		before_action :get_product, only: %i[add_cart]
		before_action :authenticate_user!
		before_action -> {check_user_roles(["user"])}

		def index
			render :index, status: :ok
		end

		def add_cart
			if !@product.blank? && !@cart.nil?	

				if @product_count < @product.quantity
					@cart.add_product(@product)
					@message = "Product Added To Cart"
					render 'show_message', status: :ok
				else
					@message = "Not enough product"
					render 'error'
				end
			else
				@message = "Product not find"
				render 'error', status: :bad_request
			end
		end

		def remove_cart
			if @cart && @cart_item
				@cart.remove_product(@cart_item)
				@message = "Product Removed from Cart"
				render 'show_message', status: :ok
			else
				@message = "Cart Item Not Found"
				render 'error', status: :bad_request
			end
		end

		def empty_the_cart
			if !@cart.cart_items.blank?
				@cart.cart_items.destroy_all
				@message = "Cart emptied"
				render 'show_message', status: :ok
			else
				@message = "Cart already empty"
				render 'error', status: :not_found
			end
		end

		def provide
			unless @cart.cart_items.blank?
				@order = current_user.orders.build(user_name: @username, order_status: :pending)
				if @order.save
					@cart.cart_items.each do |cart_item|
						@order.add_product(cart_item.product)
						cart_item.destroy
					end
					@message = "Provide accepted"
					render 'show_message', status: :ok
				else
					@message = @order.errors.full_messages.to_sentence
					render 'error', status: :bad_request
				end
			else
				@message = "Cart is empty"
				render 'error', status: :not_found
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
			@product = Product.find_by(id: params[:product_id])
			@product_count = @cart.cart_items.where(product_id: params[:product_id]).count
		end
	end
end