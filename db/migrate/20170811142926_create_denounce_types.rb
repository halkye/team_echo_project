class CreateDenounceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :denounce_types do |t|
      t.string :name
      t.integer :value

      t.timestamps
    end
  end
end
