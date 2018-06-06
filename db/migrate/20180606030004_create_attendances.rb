class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.references :user, null:false, foreign_key: true
      t.date :date, null:false
      t.integer :atnd1
      t.integer :atnd2
      t.integer :atnd3
      t.integer :atnd4
      t.integer :atnd5
      t.time :come_at
      t.time :left_at

      t.timestamps
    end
  end
end
