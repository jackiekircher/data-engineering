class Transaction < ActiveRecord::Base

  ##
  # item (Item)
  #   the item that was traded in the transaction
  belongs_to :item
  validates  :item, presence: true

  ##
  # merchant (Merchant)
  #   the merchant who sold the item in the transaction
  has_one :merchant, through: :item

  ##
  # purchaser (Purchaser)
  #   the purchaser who made the transaction
  belongs_to :purchaser
  validates  :purchaser, presence: true

  ##
  # quantity (Integer)
  #   the number of items in the transaction ( >=0 )
  validates :quantity, presence: true,
                       numericality: { greater_than: 0 }

  def total_price
    item.price * quantity
  end
end
