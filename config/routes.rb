Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/celebrities/search", to: "celebrities#search", as: "celebrity_search"
  get "/celebrities", to: "celebrities#index", as: "celebrities"
  get "/celebrities/:id", to: "celebrities#show", as: "celebrity"
  post "/celebrities", to: "celebrities#create"
  put "/celebrities/:id", to: "celebrities#update"
  delete "/celebrities/:id", to: "celebrities#destroy"

  get "/pokemons/initdb", to: "pokemons#initdb"
  get "/pokemons/search", to: "pokemons#search", as: "pokemon_search"
  get "/pokemons/:id", to: "pokemons#show", as: "pokemon"
  get "/pokemons/:name(/:height(/:type1(/:type2)))", to: "pokemons#show", as: "pokemon_update"
  get "/pokemons/:id/edit", to: "pokemons#edit", as: "edit_pokemon"

  get "/pokemons", to: "pokemons#index", as: "pokemons"

  root "pokemons#index"
end
