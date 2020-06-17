class CelebritiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_data
  before_action :find_by_id, only: [:show, :destroy]
  @@celebrities = [
    { id: "1", name:"Lindsay Lohan", notability: "Parent Trap", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKWJy_Rk9xBJIiAUUmb1yrrhifvPttpBr0hwz9TiLspFSHwf_RH6uyZgTC&s"},
    { id: "2", name: "Adam Sandler", notability: "Big Daddy", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrqjgEZ7XyMGhDzRQqJDIM9qnZT2boyZHkc0rYAt1X_2aPleIK3gBfrH3n&s" },
    { id: "3", name: "Micheal Jackson", notability: "Billie Jean", url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMHC3L4ibxAXFAk5OHMxJmrDC0u9X8cM3MAYTyuwjEK9nEvN0M3hyFObRu&s" },
  ]
  
  #Show all celebrities
  def index
  end
  
  #Show a single celebrity
  def show
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
      notability = "Known"
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
    end

    def find_by_id
      arr_celeb = @celebrities.filter {|celeb| celeb[:id] == params[:id]}
      if arr_celeb
        @celebrity = arr_celeb[0]
      else
        @celebrity = nil
      end
    end
end