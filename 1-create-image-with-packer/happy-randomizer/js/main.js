$('#randomizer').on('click', function() {
    var url= "./resources/quotes.json";
    $.getJSON(url, function(response) {
    	var arrayRandom = Math.floor(Math.random() * response.length);
		$('#image img').attr('src', response[arrayRandom].image);
		$('#quote span').html(response[arrayRandom].quote);
	}); //end getJSON
});