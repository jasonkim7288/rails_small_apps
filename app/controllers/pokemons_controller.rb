class PokemonsController < ApplicationController
  before_action :prepare_data

  @@types = { fire: "red", water: "blue", grass: "green", electric: "yellow", flying: "skyblue", bug: "darkgreen", poison: "purple" }
  
  def index

  end

  def show
    @pokemon = @pokemons.find {|pokemon| pokemon[:name] == params[:name]}
    if @pokemon && @pokemon != {}
      if params[:level]
        @pokemon[:level] = params[:level]
      end

      if params[:type1]
        @pokemon[:type1] = params[:type1]
      end

      if params[:type2]
        @pokemon[:type2] = params[:type2]
      end
    end
  end

  private
    def prepare_data
      @@pokemons = []

      # get json formatted information from Pokeapi 
      # response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=964")
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=22")

      # parse json
      json_results = JSON.parse(response.body, {symbolize_names: true})[:results]
      if json_results && json_results != []
        json_results.each do |pokemon_info|
          pokemon = {}
          pokemon[:name] = pokemon_info[:name]
          pokemon[:img] = "https://pokeres.bastionbot.org/images/pokemon/#{pokemon_info[:url].split("/").last.to_i}.png"

          # get json formatted information from Pokeapi
          response_each_pokemon = HTTParty.get(pokemon_info[:url])
          # parse json
          json_results_each_pokemon = JSON.parse(response_each_pokemon.body, {symbolize_names: true})

          pokemon[:level] = json_results_each_pokemon[:height]
          pokemon[:type1] = json_results_each_pokemon[:types][0][:type][:name]
          pokemon[:color_type1] = get_color(pokemon[:type1])
         
          if json_results_each_pokemon[:types].length > 1
            pokemon[:type2] = json_results_each_pokemon[:types][1][:type][:name]
            pokemon[:color_type2] = get_color(pokemon[:type2])
          end

          @@pokemons.push(pokemon)
        end
      end

      # need to assigh class variable to instance variable because the class variable couldn't be used in Views
      @pokemons = @@pokemons
    end

    # return the color matched, and return "black" if not matched
    def get_color(type)
      return @@types.has_key?(type.to_sym) ? @@types[type.to_sym] : "black"
    end
end