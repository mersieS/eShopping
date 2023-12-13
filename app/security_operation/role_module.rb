module RoleModule
    @@admin = "admin"
    @@superadmin = "superadmin"
    @@user = "user"

    def self.all_roles
        [@@admin, @@superadmin, @@user]
    end

    def self.admin_and_super_admin
        [@@admin, @@superadmin]
    end

    def self.superadmin
        [@@superadmin]
    end
end