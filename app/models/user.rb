# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one :cart, dependent: :destroy
  has_one :user_role, dependent: :destroy
  has_many :orders, dependent: :destroy
  after_create :create_cart
  after_create :assign_role

  validates :name, presence: true
  validates :username, presence: true

  private
    def create_cart
      Cart.create(user_id: self.id)
    end

    def assign_role
      UserRole.create(user_id: self.id, role_id: 1)
    end
end
