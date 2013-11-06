var map;
var markers = [];
function initialize() {
  var mapOptions = {
    zoom: 14,
    center: new google.maps.LatLng(55.748758, 37.6174),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
  google.maps.event.addListener(map, 'zoom_changed', function() {
    var zoomLevel = map.getZoom();
    console.log(zoomLevel);
  });

  google.maps.event.addListener(map, 'idle', loadMarkders);


}

function loadMarkders() {
  bounds = map.getBounds();
  $.ajax({
    url: "/api/v0/points",
    data: {
      latitude: [bounds['ea']['b'], bounds['ea']['d']],
      longitude: [bounds['ia']['b'], bounds['ia']['d']],
      price_from: $('#price_from').val(),
      price_to: $('#price_to').val()
    }
  })
    .done(function( data ) {
      deleteMarkers();
      console.log(data.length)
      for (i=0, length = data.length; i < length; i++) {
        createMarker(new google.maps.LatLng(data[i]['latitude'], data[i]['longitude']), data[i]['name'] + " " +data[i]['price']);
      }
    });
}

function loadScript() {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "http://maps.googleapis.com/maps/api/js?v=3.13&sensor=false&callback=initialize";
  document.body.appendChild(script);
}

function createMarker(position, title) {
  marker = new google.maps.Marker({
    position: position,
    map: map,
    title: title
  });
  markers.push(marker)
}

function setAllMap(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

function clearMarkers() {
  setAllMap(null);
}

function deleteMarkers() {
  clearMarkers();
  markers = [];
}

window.onload = loadScript;


$(function() {
  $('#search_price').on('click', loadMarkders)
});

