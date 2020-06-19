// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import 'bootstrap/dist/js/bootstrap'
import 'bootstrap/dist/css/bootstrap'

import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete';

$(document).on('turbolinks:load', function() {
  // This is for pokemon search
  const names_pokemon = JSON.parse(document.getElementById('search-data-pokemon').dataset.names)
  const searchInputPokemon = document.getElementById('search_text_pokemon');

  if (names_pokemon && searchInputPokemon) {
    new autocomplete({
      selector: searchInputPokemon,
      minChars: 1,
      source: function(term, suggest){
          term = term.toLowerCase();
          const choices = names_pokemon;
          const matches = [];
          for (let i = 0; i < choices.length; i++)
              if (~choices[i].toLowerCase().indexOf(term)) matches.push(choices[i]);
          suggest(matches);
      },
    });
  }
});
