class AdminPolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record, (user.present? && (user.superadmin? || user.admin?)))
  end
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
