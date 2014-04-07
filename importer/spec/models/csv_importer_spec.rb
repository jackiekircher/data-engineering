require 'spec_helper'

describe CSVImporter do

  describe "persist" do

    let(:data_row) do
      content = <<END
purchaser name\titem description\titem price\tpurchase count\tmerchant address\tmerchant name
Snake Plissken\t$10 off $20 of food\t10.0\t2\t987 Fake St\tBob's Pizza
END
      StringIO.new(content)
    end

    it "creates a new purchaser if one doesn't exist for the
        name in a row" do

      CSVImporter.new(data_row).persist
      purchaser = Purchaser.find_by(name: "Snake Plissken")
      expect(purchaser).to be_persisted
    end

    it "does not create a new pruchaser if one already
        exists by the name in the row" do

      Purchaser.create(name: "Snake Plissken")
      CSVImporter.new(data_row).persist
      expect(Purchaser.all.count).to eq 1
    end

    it "creates a new merchant if one doesn't exist for the
        name in a row" do

      CSVImporter.new(data_row).persist
      merchant = Merchant.find_by(name:    "Bob's Pizza",
                                  address: "987 Fake St")
      expect(merchant).to be_persisted
    end

    it "does not create a new merchant if one already
        exists by the name in the row" do

      Merchant.create(name:    "Bob's Pizza",
                      address: "987 Fake St")
      CSVImporter.new(data_row).persist
      expect(Merchant.all.count).to eq 1
    end

    it "creates a new item if one doesn't exist for the
        name in a row" do

      CSVImporter.new(data_row).persist
      item = Item.find_by(description: "$10 off $20 of food",
                          price: 10.0)
      expect(item).to be_persisted
    end

    it "does not create a new item if one already
        exists by the name in the row" do

      merchant = Merchant.create(name:    "Bob's Pizza",
                                 address: "987 Fake St")
      Item.create(description: "$10 off $20 of food",
                  price:       10.0,
                  merchant:    merchant)
      CSVImporter.new(data_row).persist
      expect(Item.all.count).to eq 1
    end

    it "creates a transaction for the listed item for the
        listed purchaser" do

      CSVImporter.new(data_row).persist

      purchaser = Purchaser.find_by(name: "Snake Plissken")
      item = Item.find_by(description: "$10 off $20 of food",
                          price: 10.0)

      transaction = purchaser.transactions.find_by(item: item)
      expect(transaction).to be_persisted
    end

    it "creates a transaction with the listed quantity for the
        listed purchaser" do

      CSVImporter.new(data_row).persist

      purchaser = Purchaser.find_by(name: "Snake Plissken")
      item      = Item.find_by(description: "$10 off $20 of food",
                               price: 10.0)

      transaction = purchaser.transactions.find_by(item: item)
      expect(transaction.quantity).to eq 2
    end

    it "keeps a running total of transactions" do
      prices     = (0..2).map{ rand(100) + 1 }
      quantities = (0..2).map{ rand(10) + 1 }
      content    = <<END
purchaser name\titem description\titem price\tpurchase count\tmerchant address\tmerchant name
Snake Plissken\t$10 off $20 of food\t#{prices[0]}\t#{quantities[0]}\t987 Fake St\tBob's Pizza
Snake Plissken\t$10 off $20 of food\t#{prices[1]}\t#{quantities[1]}\t987 Fake St\tBob's Pizza
Snake Plissken\t$10 off $20 of food\t#{prices[2]}\t#{quantities[2]}\t987 Fake St\tBob's Pizza
END
      new_data = StringIO.new(content)

      importer = CSVImporter.new(new_data)
      importer.persist
      expect(importer.total).to eq Transaction.all.map(&:total_price).reduce(:+)
    end

  end
end
