class Merchant < ActiveRecord::Base

  ##
  # name (String)
  #   an identifier for the merchant.
  validates :name, presence: true,
                   uniqueness: { scope: :address}

  ##
  # address (String)
  #   a contact address for the merchant.
  validate :address, presence: true

  ##
  # items ([Item])
  #   a collection of Items that the merchant has sold.
  has_many :items
end
