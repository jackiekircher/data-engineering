class Purchaser < ActiveRecord::Base

  ##
  # name (String)
  #   a unique identifier for a purchaser. we must,
  #   unfortunately, assume that two purchasers with the
  #   same name are the same person since there are no other
  #   identifying values for each purchaser in our data.
  validates :name, presence: true, uniqueness: true

  ##
  # transactions ([Transaction])
  #   a collection of transactions that the purchaser has
  #   made
  has_many :transactions
end
