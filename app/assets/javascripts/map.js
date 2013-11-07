var map;
var markers = [];
var infowindow;
var cluster;
function initialize() {
  var mapOptions = {
    zoom: 14,
    center: new google.maps.LatLng(55.748758, 37.6174),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  var mcOptions = {gridSize: 50, maxZoom: 15, zoomOnClick: false};
  cluster = new MarkerClusterer(map, null, mcOptions);


  google.maps.event.addListener(map, 'zoom_changed', function() {
    var zoomLevel = map.getZoom();
    console.log('zoom level: ' + zoomLevel);
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
//      deleteMarkers();
      console.log(data.length)
      for (var i=0, length = data.length; i < length; i++) {
        createMarker(
          new google.maps.LatLng(data[i]['latitude'], data[i]['longitude']),
          data[i]['name'] + " " + data[i]['price']
        );
      }

      cluster.clearMarkers();
      cluster.addMarkers(markers);

      google.maps.event.addListener(cluster, "clusterclick", function (cluster) {
        var info = new google.maps.MVCObject;
        info.set('position', cluster.center_);

        var titles = "";
        var markers = cluster.getMarkers();
        for(var i = 0; i < markers.length; i++) {
          titles += markers[i].title + "<br/>\n";
        }

        infowindow.close();
        infowindow.setContent(titles);
        infowindow.open(map, info);

      });
    });
}

function loadScript() {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "http://maps.googleapis.com/maps/api/js?v=3.13&sensor=false&callback=initialize";
  document.body.appendChild(script);
}

function createMarker(position, title) {
  var marker = new google.maps.Marker({
    position: position,
    title: title
  });
  google.maps.event.addListener(marker, 'click', function(mk) {
    console.log(mk)
    infowindow.close();
    infowindow.setContent(marker.title);
    infowindow.open(map, marker);
  })
  markers.push(marker);
}



window.onload = loadScript;


$(function() {
  $('#search_price').on('click', loadMarkders)
});

