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

  window.addEventListener('resize', () => {
    console.log('window.innerWidth:', window.innerWidth)
    if (window.innerWidth < 576) {
      // this.getElementById('pokemon-page').setAttribute("inner_window", 1);
    }
    else {
      // this.getElementById('pokemon-page').setAttribute("inner_window", 4);
    }
  });
});
