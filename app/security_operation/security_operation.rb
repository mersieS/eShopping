module SecurityOperation
    def check_user_roles(roles)
        if roles.kind_of?(Array)
            @user_roles = UserRole.where(user: current_user)
            @user_roles.each do |user_role|
                if roles.include? user_role.role.name
                    return
                end
            end
        else
            raise Exception.new "You must give an array parameter"
        end

        render json: {message: "You have not auth"}, status: 401
    end
end