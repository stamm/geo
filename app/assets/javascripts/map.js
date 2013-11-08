var vars = {
  map: null,
  infowindow: null,
  cluster: null,
  drawingManager: null,
  polygon: null
}



function loadScript() {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "http://maps.googleapis.com/maps/api/js?v=3.13&libraries=drawing&sensor=false&callback=initialize";
  document.body.appendChild(script);
}

function initialize() {
  var mapOptions = {
    zoom: 14,
    center: new google.maps.LatLng(55.748758, 37.6174),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  vars.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);


  var mcOptions = {gridSize: 50, maxZoom: 15, zoomOnClick: false};
  vars.cluster = new MarkerClusterer(vars.map, null, mcOptions);
  google.maps.event.addListener(vars.cluster, "clusterclick", clusterClick);


  vars.infowindow = new google.maps.InfoWindow({
    content: "Loading...",
    disableAutoPan : true
  })
  google.maps.event.addListener(vars.map, 'idle', loadMarkders);


  addPolygonManager();
  addResetButton();
}


function addPolygonManager() {
  vars.drawingManager = new google.maps.drawing.DrawingManager({
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT,
      drawingModes: [
        google.maps.drawing.OverlayType.POLYGON
      ]
    },
    polygonOptions: {
      editable: true
    },
    map: vars.map
  });

  google.maps.event.addListener(vars.drawingManager, 'polygoncomplete', function(poly) {
    vars.polygon = poly;
    polygonTrigger();
    google.maps.event.addListener(vars.polygon.getPath(), 'set_at', polygonTrigger);
    google.maps.event.addListener(vars.polygon.getPath(), 'insert_at', polygonTrigger);
  });
}

function ResetControl(controlDiv) {

  // Set CSS styles for the DIV containing the control
  // Setting padding to 5 px will offset the control
  // from the edge of the map
  controlDiv.style.padding = '5px';

  // Set CSS for the control border
  var controlUI = document.createElement('div');
  controlUI.style.backgroundColor = 'white';
  controlUI.style.borderStyle = 'solid';
  controlUI.style.borderWidth = '2px';
  controlUI.style.cursor = 'pointer';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Сбросить выделенное';
  controlDiv.appendChild(controlUI);

  // Set CSS for the control interior
  var controlText = document.createElement('div');
  controlText.style.fontFamily = 'Arial,sans-serif';
  controlText.style.fontSize = '12px';
  controlText.style.paddingLeft = '4px';
  controlText.style.paddingRight = '4px';
  controlText.innerHTML = 'Сброс';
  controlUI.appendChild(controlText);

  // Setup the click event listeners: simply set the map to
  // Chicago
  google.maps.event.addDomListener(controlUI, 'click', function() {
    polygonReset();
  });
}

function addResetButton() {
  var resetControlDiv = document.createElement('div');
  var resetControl = new ResetControl(resetControlDiv, vars.map);

  resetControlDiv.index = 1;
  vars.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(resetControlDiv);
}


function loadMarkders() {
  var polygon_arr = []
  if (vars.polygon != undefined) {
    var positions = vars.polygon.getPath().getArray();
    for (var i = 0, length = positions.length; i < length; i++) {
      polygon_arr.push(positions[i].toUrlValue())
    }
  }
  $.ajax({
    url: "/api/v0/points",
    data: {
      bounds: vars.map.getBounds().toUrlValue(),
      polygon: polygon_arr.join(','),
      price_from: $('#price_from').val(),
      price_to: $('#price_to').val()
    }
  })
    .done(handleMarkers);
}

function handleMarkers(data) {
  var markers = [];
  for (var i=0, length = data.length; i < length; i++) {
    marker = createMarker(
      new google.maps.LatLng(data[i]['latitude'], data[i]['longitude']),
      data[i]['name'] + " " + data[i]['price']
    );
    markers.push(marker)
  }

  vars.cluster.clearMarkers();
  vars.cluster.addMarkers(markers);
}

function clusterClick(cluster) {
  var info = new google.maps.MVCObject;
  info.set('position', cluster.center_);

  var titles = "";
  var markers = cluster.getMarkers();
  for(var i = 0, length = markers.length; i < length; i++) {
    titles += markers[i].title + "<br/>\n";
  }
  showInfo(titles, info)

}

function showInfo(title, obj) {
  vars.infowindow.close();
  vars.infowindow.setContent('<div class="marker_content">' + title + '</div>');
  vars.infowindow.open(vars.map, obj);
}






function createMarker(position, title) {
  var marker = new google.maps.Marker({
    position: position,
    title: title
  });
  google.maps.event.addListener(marker, 'click', function() {
    showInfo(marker.title, marker);
  })
  return marker;
}

function polygonTrigger() {
  vars.drawingManager.setDrawingMode(null);
  loadMarkders();
}

function polygonReset() {
  if (vars.polygon != undefined) {
    vars.polygon.setMap(null);
    vars.polygon = null;
    loadMarkders();
  }
}





window.onload = loadScript;


$(function() {
  $('#search_form').on('click', function(e) {
    e.preventDefault();
    loadMarkders();
  })
});