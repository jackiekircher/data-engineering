require 'csv'

class CSVImporter

  def initialize(file)
    @data  = CSV.parse(file, col_sep: "\t", headers: true)
    @total = 0
  end

  def total
    @total
  end

  def persist
    @data.each do |row|
      data = parse_row(row)

      merchant    = Merchant.
                      find_or_create_by(data[:merchant])
      item        = merchant.items.
                      find_or_create_by(data[:item])
      purchaser   = Purchaser.
                      find_or_create_by(data[:purchaser])

      transaction = purchaser.transactions.
                      create(item:     item,
                             quantity: data[:quantity])

      @total += transaction.total_price
    end
  end

  private

    def parse_row(row)
     return {
       purchaser: { name: row[0] },
       item:      { description: row[1],
                    price:       row[2] },
       merchant:  { name:    row[5],
                    address: row[4] },
       quantity:  row[3]
     }
    end

end
