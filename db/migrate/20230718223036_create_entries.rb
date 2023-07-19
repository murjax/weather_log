class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.decimal :temperature, null: false
      t.decimal :humidity, null: false

      t.timestamps
    end
  end
end
