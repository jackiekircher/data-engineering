class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :item,      index: true
      t.belongs_to :purchaser, index: true
      t.integer    :quantity
      t.index      [:purchaser_id, :item_id]

      t.timestamps
    end
  end
end
