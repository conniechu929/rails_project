
var input = document.getElementById('searchTextField');
var searchBox = new google.maps.places.SearchBox(input);
google.maps.event.addListener(autocomplete, 'place_changed', function () {
    var place = autocomplete.getPlace();
    document.getElementById('city2').value = place.name;
    document.getElementById('cityLat').value = place.geometry.location.lat();
    document.getElementById('cityLng').value = place.geometry.location.lng();
    //alert("This function is working!");
    //alert(place.name);
   // alert(place.address_components[0].long_name);

});
google.maps.event.addDomListener(window, 'load', initialize);
