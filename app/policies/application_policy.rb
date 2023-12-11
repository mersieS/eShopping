# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record, :role_resault

  def initialize(user, record, role_resault = false)
    @user = user
    @record = record
    @role_resault = role_resault
  end

  def index?
    role_resault
  end

  def show?
    role_resault
  end

  def create?
    role_resault
  end

  def new?
    create?
  end

  def update?
    role_resault
  end

  def edit?
    update?
  end

  def destroy?
    role_resault
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
