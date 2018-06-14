class CreateSchoolDays < ActiveRecord::Migration[5.2]
  def change
    create_table :school_days, primary_key: ["date"] do |t|
      t.date :date, null: false
      t.boolean :school_flag, null: false

      t.timestamps
    end
  end
end
