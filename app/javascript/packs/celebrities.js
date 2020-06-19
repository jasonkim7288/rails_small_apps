import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete';

$(document).on('turbolinks:load', function() {
  // This is for celebrity search
  const names_celebrity = JSON.parse(document.getElementById('search-data-celebrity').dataset.names)
  const searchInputCelebrity = document.getElementById('search_text_celebrity');

  if (names_celebrity && searchInputCelebrity) {
    new autocomplete({
      selector: searchInputCelebrity,
      minChars: 1,
      source: function(term, suggest){
          term = term.toLowerCase();
          const choices = names_celebrity;
          const matches = [];
          for (let i = 0; i < choices.length; i++)
              if (~choices[i].toLowerCase().indexOf(term)) matches.push(choices[i]);
          suggest(matches);
      },
    });
  }
});