class PokemonsController < ApplicationController
  before_action :prepare_data

  def index
    render json: @pokemons
  end

  def show
    @pokemon = {}
    @pokemon = @pokemons.find {|pokemon| pokemon[:name] == params[:name]}
    if @pokemon != {}
      @pokemon[:img] = "https://pokeres.bastionbot.org/images/pokemon/#{@pokemon[:url].split("/").last.to_i}.png"

      # get json formatted information from Pokeapi
      response = HTTParty.get(@pokemon[:url])
      # parse json
      json_results = JSON.parse(response.body, {symbolize_names: true})
      
      if params[:level]
        @pokemon[:level] = params[:level]
      else
        @pokemon[:level] = json_results[:height]
      end

      if params[:type1]
        @pokemon[:type1] = params[:type1]
      else
        @pokemon[:type1] = json_results[:types][0][:type][:name]
      end

      if params[:type2]
        @pokemon[:type2] = params[:type2]
      else
        if json_results[:types].length == 1
          @pokemon[:type2] = @pokemon[:type1]
        else
          @pokemon[:type2] = json_results[:types][1][:type][:name]
        end
      end
    end

    html_str = "<h1>#{@pokemon[:name]}</h1><img src=\"#{@pokemon[:img]}\" width=400px><br /><h3>level: #{@pokemon[:level]}</h3><h3>type1: #{@pokemon[:type1]}</h3><h3>type2: #{@pokemon[:type2]}</h3>"

    render html: html_str.html_safe
  end

  private
    def prepare_data
      # get json formatted information from Pokeapi 
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=964")

      # parse json
      json_results = JSON.parse(response.body, {symbolize_names: true})[:results]
      if json_results && json_results != []
        @@pokemons = [*json_results]
        pp @@pokemons
      end
      @pokemons = @@pokemons
    end
end