class CelebritiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_data
  before_action :find_by_id, only: [:show, :destroy]
  before_action :find_by_name, only: [:search]
  @@celebrities = [
    { id: "2", name: "Adam Sandler", notability: "Big Daddy", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrqjgEZ7XyMGhDzRQqJDIM9qnZT2boyZHkc0rYAt1X_2aPleIK3gBfrH3n&s" },
    { id: "1", name:"Lindsay Lohan", notability: "Parent Trap", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKWJy_Rk9xBJIiAUUmb1yrrhifvPttpBr0hwz9TiLspFSHwf_RH6uyZgTC&s"},
    { id: "3", name: "Micheal Jackson", notability: "Billie Jean", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMHC3L4ibxAXFAk5OHMxJmrDC0u9X8cM3MAYTyuwjEK9nEvN0M3hyFObRu&s" },
  ]
  @@names = []
  
  #Show all celebrities
  def index
  end
  
  #Show a single celebrity
  def show
    if @celebrity
      # Wikipedia usually accepts names only starting with the capital letter, and special characters need to be traslated to url query format like "%2C", "+", etc.
      searchable_name = CGI.escape(@celebrity[:name].split(" ").map {|str| str.capitalize}.join(" "))

      # get json formatted information from Wikipedia 
      req_url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=#{searchable_name}"
      response = HTTParty.get(req_url)
      p req_url

      # parse json
      json_result = JSON.parse(response.body, { symbolize_names: true})
      if json_result && json_result[:query] && json_result[:query][:pages] && !json_result[:query][:pages].has_key?(:"-1")
        @wiki = json_result[:query][:pages].values[0][:extract]
      else
        @wiki = @celebrity[:notability]
      end
    else
      redirect_to celebrities_url, alert: 'No result'
    end
  end

  # Get the search text and redirect to Show
  def search
    if @celebrity
      redirect_to celebrity_path(@celebrity[:id])
    else
      redirect_to celebrities_url, alert: 'No result'
    end
  end

  #Create a new celebrity
  def create
    uuid = UUID.new.generate
    
    # get json formatted information from google image search 
    response = HTTParty.get("https://www.googleapis.com/customsearch/v1?key=#{Rails.application.credentials.dig(:google, :api_key)}&q=#{params[:name].gsub(" ", "%20")}&searchType=image")

    # parse json
    json_results = JSON.parse(response.body, {symbolize_names: true})

    if params[:notability]
      notability = params[:notability]
    elsif json_results[:searchInformation][:totalResults].to_i > 0
      notability = json_results[:items][0][:snippet]
    else
      notability = "Unknown"
    end
    

    url = "https://placekitten.com/400/300"
    if json_results[:searchInformation][:totalResults].to_i > 0
      url = json_results[:items][0][:image][:thumbnailLink]
    end

    @@celebrities.push({id: uuid, name: params[:name], notability: notability, url: url})

    redirect_to root_path
  end
  
  #Update a celebrity
  def update
  end
  
  #Remove a celebrity
  def destroy
    @celebrities.delete(@celebrity)
    redirect_to root_path
  end

  private
    def setup_data
      @celebrities = @@celebrities
      if @celebrities != []
        @names = @celebrities.map {|celebrity| celebrity[:name]}
        puts @names
      end
    end

    def find_by_id
      arr_celebrity = @celebrities.filter {|celebrity| celebrity[:id] == params[:id]}
      if arr_celebrity
        @celebrity = arr_celebrity[0]
      else
        @celebrity = nil
      end
    end

    def find_by_name
      arr_celebrity = @celebrities.filter {|celebrity| celebrity[:name].downcase == params[:search_text_celebrity].downcase}
      if arr_celebrity
        @celebrity = arr_celebrity[0]
      else
        @celebrity = nil
      end
    end
end