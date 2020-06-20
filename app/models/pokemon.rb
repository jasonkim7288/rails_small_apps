class Pokemon < ApplicationRecord
  def self.types
    return { fire: "red", water: "blue", grass: "green", electric: "#86864b", flying: "skyblue", bug: "darkgreen", poison: "purple" }
  end

  def type1_color
    return Pokemon.types.has_key?(self.type1.to_sym) ? Pokemon.types[self.type1.to_sym] : "black"
  end

  def type2_color
    return Pokemon.types.has_key?(self.type2.to_sym) ? Pokemon.types[self.type2.to_sym] : "black"
  end
end
