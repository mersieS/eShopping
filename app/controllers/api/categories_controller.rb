module Api
    class CategoriesController < ApplicationController
        before_action :get_category, only: %i[update show destroy]
        before_action :authenticate_user!

        def index
            @categories = Category.order(created_at: :asc)
            unless @categories.blank?
                @message = "Categories Listed"
                render :index, status: :ok
            else
                @message = "Categories List is Empty"
                handler_error(:not_found)
            end
        end

        def show
            unless @category.blank?
                @message = "Category Shown"
                render :show, status: :ok
            else
                @message = "No category"
                handler_error(:not_found)
            end 
        end

        def get_by_name
            @categories = Category.where(name: params[:name]).order(created_at: :desc)
            unless @categories.blank?
                @message = "Categories Listed"
                render 'index', status: :ok
            else
                @message = "Categories List is Empty"
                handler_error(:not_found) 
            end
        end

        def create
            @category = Category.create(category_params)
            if @category.valid?
                @category.save
                @message = "Category Created"
                render :create, status: :ok
            else
                @message = @category.errors.full_messages
                handler_error(:bad_request)
            end
        end

        def update
            unless @category.blank?
                @category.update(category_params)
                @message = "Category Updated"
                render :update, status: :ok
            else
                @message = @category.erros.full_messages
                handler_error(:bad_request)
            end
        end

        def destroy
            unless @category.blank?
                @category.destroy
                @message = "Category Destroyed"
                render :destroy, status: :ok
            else
                handler_error(:bad_request)
            end
        end

        private

            def handler_error(code)
                render :error, status: code
            end

            def category_params
                params.permit(:name)
            end

            def get_category
                @category = Category.find_by(id: params[:id])
            end
    end
end