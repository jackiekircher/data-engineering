class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :address
      t.index  [:name, :address], unique: true

      t.timestamps
    end
  end
end
