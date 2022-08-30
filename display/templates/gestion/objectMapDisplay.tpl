{* Objets > échantillons > Rechercher > UID d'un échantillon > Modifier > *}
<script type="text/javascript" charset="utf-8" src="display/javascript/ol-v4.2.0-dist/ol.js"></script>
<link rel="stylesheet" type="text/css" href="display/javascript/ol-v4.2.0-dist/ol.css">

<div id="map" class="map"></div>
{if $mapIsChange == 1}
<div id="radar">
<a href="#">
<img src="display/images/radar.png" height="30">{t}Repérez votre position !{/t}</a></div>
{/if}
<script>
var earth_radius = 6389125.541;
var zoom = {$mapDefaultZoom};
var mapIsChange = 0;
{if $mapIsChange == 1}mapIsChange = 1;{/if}
var mapCenter = [{$mapDefaultX}, {$mapDefaultY}];
{if strlen({$data.wgs84_x})>0 && strlen({$data.wgs84_y})>0}
	mapCenter = [{$data.wgs84_x}, {$data.wgs84_y}];
{/if}
function getStyle(libelle) {
	libelle = libelle.toString();
	var styleRed = new ol.style.Style( {
		image: new ol.style.Circle({
		    radius: 6,
		    fill: new ol.style.Fill({
		          color: [255, 0, 0, 0.5]
		 	}),
			stroke: new ol.style.Stroke( {
				color: [255 , 0 , 0 , 1],
				width: 1
			})
		}),
		text: new ol.style.Text( {
			textAlign: 'Left',
			text: libelle,
			textBaseline: 'middle',
			offsetX: 7,
			offsetY: 0,
			font: 'bold 12px Arial',
			/*fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.1)' }),
			stroke : new ol.style.Stroke({ color : 'rgba(255, 0, 0, 1)' })*/
		})
	});
return styleRed;
}


var attribution = new ol.control.Attribution({
  collapsible: false
});
var mousePosition = new ol.control.MousePosition( {
    coordinateFormat: ol.coordinate.createStringXY(2),
    projection: 'EPSG:4326',
    target: undefined,
    undefinedHTML: '&nbsp;'
});
var view = new ol.View({
  	center: ol.proj.fromLonLat(mapCenter),
    zoom: zoom
  });
var map = new ol.Map({
  controls: ol.control.defaults({ attribution: false }).extend([attribution]),
  target: 'map',
  view: view
});

var layer = new ol.layer.Tile({
  source: new ol.source.OSM()
});

function transform_geometry(element) {
  var current_projection = new ol.proj.Projection({ code: "EPSG:4326" });
  var new_projection = layer.getSource().getProjection();

  element.getGeometry().transform(current_projection, new_projection);
}

map.addLayer(layer);
var coordinates;
var point;
var point_feature;
var features = new Array();
/*
 * Traitement de chaque localisation
 */

coordinates = [{$data.wgs84_x}, {$data.wgs84_y}];
 point = new ol.geom.Point(coordinates);
 point_feature = new ol.Feature ( {
	geometry: point
});
//point_feature.setStyle(getStyle({$localisation[lst].localisation_id}));
var displayname = "{$data.uid} {$data.identifier}" ;
point_feature.setStyle(getStyle(displayname ));
features.push ( point_feature) ;

/*
 * Fin d'integration des points
 * Affichage de la couche
 */
var layerPoint = new ol.layer.Vector({
  source: new ol.source.Vector( {
    features: features
  })
});
features.forEach(transform_geometry);
map.addLayer(layerPoint);
map.addControl(mousePosition);


if ( mapIsChange == 1) {
/*
 * Traitement de la localisation par clic sur le radar
 * (position approximative du terminal)
 */
 $("#radar").click(function () {
	 if (navigator && navigator.geolocation) {
	        navigator.geolocation.getCurrentPosition( function (position) {
	        	var lon = position.coords.longitude;
	        	var lat = position.coords.latitude;
	        	$("#wgs84_x").val(lon);
	        	$("#wgs84_y").val(lat);
	        	var lonlat3857 = ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
	        	point.setCoordinates (lonlat3857);
	        	map.getView().animate({ center : lonlat3857, duration : 2000 });
	        });
	 }

 });

	$(".position").change(function () {
		var lon = $("#wgs84_x").val();
		var lat = $("#wgs84_y").val();
		if (lon.length > 0 && lat.length > 0) {
			var lonlat3857 = ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
	        point.setCoordinates (lonlat3857);
		}
	});

map.on('click', function(evt) {
	  var lonlat3857 = evt.coordinate;
	  var lonlat = ol.proj.transform(lonlat3857, 'EPSG:3857', 'EPSG:4326');
	  var lon = lonlat[0];
	  var lat = lonlat[1];
	  point.setCoordinates (lonlat3857);
	  $("#wgs84_x").val(lon);
	  $("#wgs84_y").val(lat);
});
}

function setPoint(lon, lat) {
	var lonlat3857 = ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
	point.setCoordinates (lonlat3857);
	view.setCenter(lonlat3857);
}
</script>
