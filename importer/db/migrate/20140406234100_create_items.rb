class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string     :description
      t.decimal    :price, precision: 10, scale: 2
      t.belongs_to :merchant, index: true
      t.index      [:description, :price, :merchant_id], unique: true

      t.timestamps
    end
  end
end
