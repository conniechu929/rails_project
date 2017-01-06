class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :business
      t.string :address
      t.string :city
      t.string :state
      t.references :user, index: true

      t.timestamps
    end
  end
end
