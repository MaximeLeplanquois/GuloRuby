//= require jquery
//= require jquery-ui
//= require_tree .

function beginningMatcher(data, request, response){
    var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
    response( $.grep( data, function( item ){
        return matcher.test( item );
    }) );
}

$(document).ready(function(){
    //Location regex
    $('#receipt_location').autocomplete({
        source: function(request, response){
            beginningMatcher($('#receipt_location').data('autocomplete-source'), request, response)
        },
        minLength: 1
    });
});