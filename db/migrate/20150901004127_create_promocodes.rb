class CreatePromocodes < ActiveRecord::Migration
  def change
    create_table :shoppe_promocodes do |t|
      t.string :title
      t.string :code
      t.string :discount_type
      t.float :discount_value
      t.integer :usage_limit, default: 0
      t.integer :times_used, default: 0
      t.datetime :active_start_date
      t.datetime :active_end_date

      t.timestamps null: false
    end
  end
end
