class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :school_year, null: false
      t.integer :attendance_number, null: false
      t.string :user_name, null: false
      t.string :password, null: false
      t.string :card_id, null: false

      t.timestamps
    end
  end
end
