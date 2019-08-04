class CreateHotelPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :hotel_plans do |t|
      t.string :plan_name, null: false
      t.string :room_name, null: false
      t.integer :price, null: false

      t.timestamps
    end
    add_index :hotel_plans, [:plan_name, :room_name], unique: true
  end
end
