class PokemonsController < ApplicationController
  before_action :prepare_data, only: [:index]
  before_action :get_list

  @@types = { fire: "red", water: "blue", grass: "green", electric: "yellow", flying: "skyblue", bug: "darkgreen", poison: "purple" }
  @@pokemons = []
  @@names = []

  def index

  end

  def show
    @pokemon = @pokemons.find {|pokemon| pokemon[:name] == params[:name]}
    if @pokemon && @pokemon != {}
      if params[:height]
        @pokemon[:height] = params[:height]
      end

      if params[:type1]
        @pokemon[:type1] = params[:type1]
        @pokemon[:color_type1] = get_color(@pokemon[:type1])
      end

      if params[:type2]
        @pokemon[:type2] = params[:type2]
        @pokemon[:color_type2] = get_color(@pokemon[:type2])
      end
    else
      redirect_to pokemons_url, alert: 'No result'
    end
  end

  def search
    redirect_to pokemon_path(params[:search_text])
  end

  private
    def prepare_data
      # If the data is already loaded, don't load again
      return if @@pokemons && @@pokemons != []

      # get json formatted information from Pokeapi 
      # response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=964")
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=22")

      # parse json
      json_results = JSON.parse(response.body, {symbolize_names: true})[:results]
      if json_results && json_results != []
        json_results.each do |pokemon_info|
          pokemon = {}
          pokemon[:id] = pokemon_info[:url].split("/").last.to_i
          pokemon[:name] = pokemon_info[:name]
          pokemon[:img] = "https://pokeres.bastionbot.org/images/pokemon/#{pokemon[:id]}.png"

          # get json formatted information from Pokeapi
          response_each_pokemon = HTTParty.get(pokemon_info[:url])
          # parse json
          json_results_each_pokemon = JSON.parse(response_each_pokemon.body, {symbolize_names: true})

          pokemon[:height] = (json_results_each_pokemon[:height].to_i / 10.0).round(1)
          pokemon[:weight] = (json_results_each_pokemon[:weight].to_i / 10.0).round(1)
          pokemon[:type1] = json_results_each_pokemon[:types][0][:type][:name]
          pokemon[:color_type1] = get_color(pokemon[:type1])
         
          if json_results_each_pokemon[:types].length > 1
            pokemon[:type2] = json_results_each_pokemon[:types][1][:type][:name]
            pokemon[:color_type2] = get_color(pokemon[:type2])
          end

          @@pokemons.push(pokemon)
          @@names.push(pokemon_info[:name])
        end
      end
    end

    # return the color matched, and return "black" if not matched
    def get_color(type)
      return @@types.has_key?(type.to_sym) ? @@types[type.to_sym] : "black"
    end

    # whenever action is excuted, @pokemons and @names should be re-assigned
    def get_list
      # need to assigh class variable to instance variable because the class variable couldn't be used in Views
      @pokemons = @@pokemons
      # @names is for autocomplete
      @names = @@names.sort!
    end
end