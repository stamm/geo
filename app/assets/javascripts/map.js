var map;
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
      position: google.maps.ControlPosition.TOP_RIGHT,
      drawingModes: [
//        google.maps.drawing.OverlayType.MARKER,
//        google.maps.drawing.OverlayType.CIRCLE,
//        google.maps.drawing.OverlayType.POLYLINE,
//        google.maps.drawing.OverlayType.RECTANGLE,
        google.maps.drawing.OverlayType.POLYGON
      ]
    },
    polygonOptions: {
      editable: true
    }
  });
  drawingManager.setMap(map);

  google.maps.event.addListener(drawingManager, 'polygoncomplete', function(poly) {
    polygon = poly

    polygonTrigger()

    google.maps.event.addListener(polygon.getPath(), 'set_at', function() {
      polygonTrigger()
    });

    google.maps.event.addListener(polygon.getPath(), 'insert_at', function() {
      polygonTrigger()
    });
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
      polygon_arr.push(positions[i].toUrlValue())
    }
  }
  $.ajax({
    url: "/api/v0/points",
    data: {
      bounds: map.getBounds().toUrlValue(),
      polygon: polygon_arr.join(','),
      price_from: $('#price_from').val(),
      price_to: $('#price_to').val()
    }
  })
    .done(function( data ) {
//      deleteMarkers();
      console.log(data.length)
      var markers = [];
      for (var i=0, length = data.length; i < length; i++) {
        marker = createMarker(
          new google.maps.LatLng(data[i]['latitude'], data[i]['longitude']),
          data[i]['name'] + " " + data[i]['price']
        );
        markers.push(marker)
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
        infowindow.setContent('<div class="marker_content">' + titles + '</div>');
        infowindow.open(map, info);

      });
    });
}

function polygonTrigger() {
  drawingManager.setDrawingMode(null);
  loadMarkders();
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
    infowindow.setContent('<div class="marker_content">' + marker.title + '</div>');
    infowindow.open(map, marker);
  })
  return marker
}

function resetPolygon() {
  polygon.setMap(null);
  polygon = null;
  loadMarkders();
}


window.onload = loadScript;


$(function() {
  $('#search_form').on('click', function(e) {
    e.preventDefault();
    loadMarkders();
  })
  $('#reset_button').on('click', resetPolygon)
});

