Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/celebrities", to: "celebrities#index", as: "celebs"
  get "/celebrities/:id", to: "celebrities#show", as: "celeb"
  post "/celebrities", to: "celebrities#create"
  put "/celebrities/:id", to: "celebrities#update"
  delete "/celebrities/:id", to: "celebrities#destroy"
  root "celebrities#index"

  get "/pokemons/:name(/:level(/:type1(/:type2)))", to: "pokemons#show", as: "pokemon"
  get "/pokemons", to: "pokemons#index", as: "pokemons"
end
