//= require jquery
//= require jquery-ui

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
        minLength: 0
    }).focus(function () {
        $(this).autocomplete("search", $(this).val());
    });
    //Store regex
    $('#receipt_store').autocomplete({
        source: function(request, response){
            stores = $('#receipt_store').data('autocomplete-source').filter(val => val[1] == $('#receipt_location').val()).map(val => val[0])
            beginningMatcher(stores, request, response)
        },
        minLength: 0
    }).focus(function () {
        $(this).autocomplete("search", $('#receipt_store').val());
    });
});