module Api
    class ProductsController < ApplicationController
        before_action :get_product, only: %i[update show destroy]
        before_action :authenticate_user!
        
        def index
            @products = Product.order(created_at: :asc)
            unless @products.blank?
                @message = "Products Listed"
                render :index, status: :ok
            else
                @message = "Products List is Empty"
                handler_error(:not_found)
            end
        end

        def show
            unless @product.blank?
                @message = "Product Shown"
                render :show, status: :ok
            else
                @message = "No Product"
                handler_error(:not_found)
            end 
        end

        def get_by_name
            @products = Product.where(name: params[:name]).order(created_at: :desc)
            unless @products.blank?
                @message = "Products Listed"
                render 'index', status: :ok
            else
                @message = "Products List is Empty"
                handler_error(:not_found) 
            end
        end

        def create
            @product = Product.create(product_params)
            authorize(@product)
            if @product.valid?
                @product.save
                @message = "Product Created"
                render :create, status: :ok
            else
                @message = @product.errors.full_messages
                handler_error(:bad_request)
            end
        end

        def update
            authorize(@product)
            unless @product.blank?
                @product.update(product_params)
                @message = "Product Updated"
                render :update, status: :ok
            else
                @message = @product.erros.full_messages
                handler_error(:bad_request)
            end
        end

        def destroy
            authorize(@product)
            unless @product.blank?
                @product.destroy
                @message = "Product Destroyed"
                render :destroy, status: :ok
            else
                handler_error(:bad_request)
            end
        end

        private
            def handler_error(code)
                render :error, status: code
            end

            def product_params
                params.permit(:name, :description, :quantity, :price, :product_image, :category_id)
            end

            def get_product
                @product = Product.find_by(id: params[:id])
            end
    end
end