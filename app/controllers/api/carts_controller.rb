module Api
    class CartsController < ApplicationController
      before_action :get_cart
      before_action :get_cart_item, only: %i[remove_cart]
      before_action :get_product, only: %i[add_cart]
      before_action :authenticate_user!
  
      def index
        unless @cart.cart_items.blank?
          render json: {data: @cart, products: {product: @cart.products, cart_items: @cart.cart_items}}
        else
          render json: "Cart is empty"
        end
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
        unless @cart.nil? && @cart_item.blank?
            @cart.remove_product(@cart_item)
            @message = "Product Removed from Cart"
            render json: @message, status: :ok
        else
            handler_error(:bad_request)
        end
      end

      def provide
        unless @cart.cart_items.blank?
          @cart.cart_items.each do |cart_item|
            @product = Product.find_by(id: cart_item.product_id)
            @product.update(quantity: (@product.quantity - 1))
          end

          @cart.cart_items.each do |cart_item|
            @cart.remove_product(cart_item)
          end
          render json: "Provide accepted"
        else
          render json: "Cart is empty"
        end
      end
      
      private
  
      def get_cart
        @cart = current_user.cart
      end

      def get_cart_item
        @cart_item = CartItem.find_by(cart_id: @cart.id, id: params[:id])
      end

      def get_product
        @product = Product.find_by(id: params[:id])
      end
    end
  end
