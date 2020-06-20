class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :rest_id, null: false
      t.string :name, null: false
      t.string :img_url, null: false
      t.string :height, null: false
      t.string :weight, null: false
      t.string :type1, null: false
      t.string :type2
      t.string :color_type1, null: false
      t.string :color_type2

      t.timestamps
    end
  end
end
