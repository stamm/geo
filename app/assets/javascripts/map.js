var map;
var markers = [];
var infowindow;
var cluster;
var drawingManager;
var polygon;
function initialize() {
  var mapOptions = {
    zoom: 14,
    center: new google.maps.LatLng(55.748758, 37.6174),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  var mcOptions = {gridSize: 50, maxZoom: 15, zoomOnClick: false};
  cluster = new MarkerClusterer(map, null, mcOptions);


  drawingManager = new google.maps.drawing.DrawingManager({
//    drawingMode: google.maps.drawing.OverlayType.MARKER,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_LEFT,
      drawingModes: [
//        google.maps.drawing.OverlayType.MARKER,
//        google.maps.drawing.OverlayType.CIRCLE,
//        google.maps.drawing.OverlayType.POLYLINE,
//        google.maps.drawing.OverlayType.RECTANGLE,
        google.maps.drawing.OverlayType.POLYGON
      ]
    }
  });
  drawingManager.setMap(map);

  google.maps.event.addListener(drawingManager, 'polygoncomplete', function(poly) {
//    console.log('finish');
//    drawingManager.setMap(null);
//    console.log(drawingManager);
//    console.log(event);
    polygon = poly
    console.log(polygon);

    drawingManager.setDrawingMode(null);
    var arr=[];
    alert(polygon.getPath().getArray())
  });

  infowindow = new google.maps.InfoWindow({
    content: "Loading...",
    disableAutoPan : true
  })


  google.maps.event.addListener(map, 'zoom_changed', function() {
    var zoomLevel = map.getZoom();
    console.log('zoom level: ' + zoomLevel);
  });

  google.maps.event.addListener(map, 'idle', loadMarkders);


}

function loadMarkders() {
  var polygon_arr = []
  if (polygon != undefined) {
    var positions = polygon.getPath().getArray();
    for (var i = 0, length = positions.length; i < length; i++) {
      polygon_arr = positions[i].toUrlValue
    }
  }
  $.ajax({
    url: "/api/v0/points",
    data: {
      bounds: map.getBounds().toUrlValue(),
      polygon: polygon_arr,
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
  script.src = "http://maps.googleapis.com/maps/api/js?v=3.13&libraries=drawing&sensor=false&callback=initialize";
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

