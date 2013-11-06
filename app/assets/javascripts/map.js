var map;

function initialize() {
  var mapOptions = {
    zoom: 11,
    center: new google.maps.LatLng(55.748758, 37.6174),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
  google.maps.event.addListener(map, 'zoom_changed', function() {
    var zoomLevel = map.getZoom();
    console.log(zoomLevel);
  });
  call_after_create_map();
}

function loadScript() {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "http://maps.googleapis.com/maps/api/js?v=3.13&sensor=false&callback=initialize";
  document.body.appendChild(script);
}

function createMarker(position) {
  marker = new google.maps.Marker({
    position: position,
    map: map,
    title: 'Click to zoom'
  });
}

window.onload = loadScript;

