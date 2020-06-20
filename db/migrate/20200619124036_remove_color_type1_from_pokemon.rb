class RemoveColorType1FromPokemon < ActiveRecord::Migration[6.0]
  def change
    remove_column :pokemons, :color_type1, :string
    remove_column :pokemons, :color_type2, :string
  end
end
