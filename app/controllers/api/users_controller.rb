module Api
    class UsersController < ApplicationController
        before_action :get_user, only: %i[change_role]
        require_relative '../../security_operation/role_module.rb'
        before_action :authenticate_user!
        before_action -> {check_user_roles(RoleModule.superadmin)}

        def index
            @users = User.order(created_at: :asc)
            render json: @users.as_json(include: {user_role: {include: :role}})
        end

        def show
            if @user
                render json: {user: @user}
            else
                render json: {error: "Bad request"}, stauts: :bad_request
            end
        end

        def change_role
            if @user
                @user_role = UserRole.find_by(user_id: @user.id).update(role_id: params[:role_id])
                render json: @user.as_json(include: {user_role: {include: :role}})
            else
                render json: {error: "Bad request"}, status: :bad_request
            end
        end

            private
        
                def get_user
                    @user = User.find_by(id: params[:id])
                end
    end
end