class Item < ActiveRecord::Base

  ##
  # description (String)
  #   a description of the item. this field might be better
  #   suited as text rather than a string but since it's an
  #   identifying attribute we need to index it. if more
  #   space is required we can convert it to a text field and
  #   index on hash instead.
  validates :description, presence: true,
                          uniqueness: { scope: [:price, :merchant] }

  ##
  # price (Decimal)
  #   the cost of the item.
  validates :price, presence: true

  ##
  # merchant (Merchant)
  #   the associated merchant that made or offered the item.
  belongs_to :merchant
  validates  :merchant, presence: true
end
