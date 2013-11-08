class MapsLoader

  constructor: ->

  load: (successCallback) ->
    @successCallback = successCallback
    if @hasLoaded != true
      @loadGoogle()
    else
      @mapsLoaded()

  loadGoogle: =>
    # reference google loader callback to local method - clean up after callback
    window.loadMaps = @loadMaps
    script = document.createElement("script")
    script.src = "http://maps.googleapis.com/maps/api/js?v=3.13&libraries=drawing&sensor=false&callback=loadMaps"
    script.type = "text/javascript"
    document.getElementsByTagName("head")[0].appendChild(script)

  mapsLoaded: =>
    @hasLoaded = true
    window.loadMaps = null
    if @successCallback
      @successCallback()
    @successCallback = null

  loadMaps: =>
    mapOptions =
      zoom: 14
      center: new google.maps.LatLng(55.748758, 37.6174)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
    @mapsLoaded()

    @loadCluster()
    @loadInfoWindow()
    @loadPolygonManager()
    @loadResetButton()

  loadCluster: =>
    mcOptions = {gridSize: 50, maxZoom: 15, zoomOnClick: false}
    @clusterer = new MarkerClusterer(@map, null, mcOptions)
    google.maps.event.addListener @clusterer, "clusterclick", (cluster) =>
      console.log('click')
      @clusterClick(cluster)

  loadInfoWindow: ->
    @infowindow = new google.maps.InfoWindow
      content: "Загрузка..."
      disableAutoPan : true

    google.maps.event.addListener(@map, 'idle', @loadMarkders)

  loadPolygonManager: ->
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingControl: true
      drawingControlOptions:
        position: google.maps.ControlPosition.TOP_RIGHT
        drawingModes: [google.maps.drawing.OverlayType.POLYGON]
      polygonOptions:
        editable: true
      map: @map

    google.maps.event.addListener @drawingManager, 'polygoncomplete', (object) =>
      @polygon = object
      @polygonTrigger()
      google.maps.event.addListener(@polygon.getPath(), 'set_at', @polygonTrigger)
      google.maps.event.addListener(@polygon.getPath(), 'insert_at', @polygonTrigger)

  ResetControl: (controlDiv) ->
    controlDiv.style.padding = '5px'

    controlUI = document.createElement('div')
    controlUI.style.backgroundColor = 'white'
    controlUI.style.borderStyle = 'solid'
    controlUI.style.borderWidth = '2px'
    controlUI.style.cursor = 'pointer'
    controlUI.style.textAlign = 'center'
    controlUI.title = 'Сбросить выделенное'
    controlDiv.appendChild(controlUI)

    controlText = document.createElement('div')
    controlText.style.fontFamily = 'Arial,sans-serif'
    controlText.style.fontSize = '12px'
    controlText.style.paddingLeft = '4px'
    controlText.style.paddingRight = '4px'
    controlText.innerHTML = 'Сброс'
    controlUI.appendChild(controlText)

    google.maps.event.addDomListener controlUI, 'click', =>
      @polygonReset()

  loadResetButton: ->
    resetControlDiv = document.createElement('div')
    @ResetControl(resetControlDiv, @map)

    resetControlDiv.index = 1
    @map.controls[google.maps.ControlPosition.TOP_RIGHT].push(resetControlDiv)


  loadMarkders: =>
    polygon_arr = []
    if @polygon?
      polygon_arr = @polygon.getPath().getArray().map (position) -> position.toUrlValue()

    $.ajax "/api/v0/points",
      data:
        bounds: @map.getBounds().toUrlValue()
        polygon: polygon_arr.join(',')
        price_from: $('#price_from').val()
        price_to: $('#price_to').val()
    .done (data) =>
      @handleMarkers(data)


  handleMarkers: (data) ->
    markers = data.map (marker) =>
      @createMarker(
        new google.maps.LatLng(marker['latitude'], marker['longitude']),
        "#{marker['name']} #{marker['price']}"
      )

    @clusterer.clearMarkers()
    @clusterer.addMarkers(markers)


  createMarker: (position, title) =>
    marker = new google.maps.Marker
      position: position
      title: title
    google.maps.event.addListener marker, 'click', =>
      @showInfo marker.title, marker
    marker

  showInfo: (title, obj) =>
    @infowindow.close();
    @infowindow.setContent('<div class="marker_content">' + title + '</div>');
    @infowindow.open(@map, obj);

  clusterClick: (cluster) =>
    info = new google.maps.MVCObject
    info.set('position', cluster.getCenter());

    titles = cluster.getMarkers().map (marker) -> marker.title
    titles = titles.join("<br/>\n")
    @showInfo(titles, info)


  polygonTrigger: ->
    @drawingManager.setDrawingMode(null)
    @loadMarkders()


  polygonReset: ->
    if @polygon?
      @polygon.setMap(null)
      @polygon = null
      @loadMarkders()


@MapsLoader = new MapsLoader()

@onload = ->
  @MapsLoader.load()


$ =>
  $('#search_form').on 'click', (e) =>
    e.preventDefault()
    @MapsLoader.loadMarkders()