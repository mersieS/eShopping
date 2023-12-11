class Product < ApplicationRecord
    has_one_attached :product_image
    after_create :send_notification

    belongs_to :category

    validates :name, presence: true, length: {minimum:2, maximum:15}
    validates :description, presence: true, length: {minimum:20, maximum: 250}
    validates :quantity, presence: true, numericality: {grater_than_or_equals: 0, less_than_or_equals: 100}
    validates :price, presence: true, numericality: {grater_than: 0}
    # validate :name_restrictions

    # def name_restrictions
    #     if !self.name.start.with('A')
    #         errors.add(:name, "Name must start with A")
    #     end
    # end

    def send_notification
        #bildirim sistemi yazilacak
    end
end
