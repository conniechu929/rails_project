class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :business
      t.string :address
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
