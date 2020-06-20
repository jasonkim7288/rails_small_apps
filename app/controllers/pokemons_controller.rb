class PokemonsController < ApplicationController
  before_action except: :init_db do
    get_names(false)
  end

  @@names = []

  def initdb
    begin
      # get the current total number of pokemons from Pokeapi
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=1")
      json_results = JSON.parse(response.body, {symbolize_names: true})

      # get the all pokemons' name and related url
      req_url = "https://pokeapi.co/api/v2/pokemon?limit=#{json_results[:count]}"
      response = HTTParty.get(req_url)
      json_results = JSON.parse(response.body, {symbolize_names: true})[:results]

      Pokemon.delete_all

      # iterate through each pokemon's related url and get the info
      json_results.each do |pokemon_info|
        # if there is already same pokemon in the Model, don't add it
        next if Pokemon.find_by_name(pokemon_indo[:name])

        pokemon = Pokemon.new

        pokemon.rest_id = pokemon_info[:url].split("/").last.to_i
        pokemon.name = pokemon_info[:name]
        pokemon.img_url = "https://pokeres.bastionbot.org/images/pokemon/#{pokemon.rest_id}.png"

        # get detailed information
        response_each_pokemon = HTTParty.get(pokemon_info[:url])
        json_results_each_pokemon = JSON.parse(response_each_pokemon.body, {symbolize_names: true})

        pokemon.height = (json_results_each_pokemon[:height].to_i / 10.0).round(1).to_s
        pokemon.weight = (json_results_each_pokemon[:weight].to_i / 10.0).round(1).to_s
        pokemon.type1 = json_results_each_pokemon[:types][0][:type][:name]

        if json_results_each_pokemon[:types].length > 1
          pokemon.type2 = json_results_each_pokemon[:types][1][:type][:name]
        end

        # save one pokemon into DB
        pokemon.save
      end

      # update names list for auto-complete
      get_names(true)

      # Redirect to index action
      redirect_to pokemons_url, notice: 'Pokemons were successfully created.'
    rescue
      # if there is an error with Rest api, return error
      # redirect_to pokemons_url, alert: 'Loading DB failed'
    end
  end

  def index
    @pokemons = Pokemon.paginate(page: params[:page], per_page: 12)
  end

  def show
    @pokemon = Pokemon.find(params[:id])
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
    if params[:search_text_pokemon]
      redirect_to pokemon_path(Pokemon.find_by_name(params[:search_text_pokemon]))
    else
      redirect_to pokemons_url, alert: 'No result'
    end
  end

  private
    # return the color matched, and return "black" if not matched
    def get_color(type)
      return @@types.has_key?(type.to_sym) ? @@types[type.to_sym] : "black"
    end

    # return names list for auto-complete
    def get_names(force)
      if force || @@names == []
        @@names = Pokemon.all.pluck(:name)
      end
      @names = @@names
    end
end