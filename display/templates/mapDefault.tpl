<script>
    var mapFields, zoom, mapData, osm;
    function setMap(tagName = "map") {
        var lmap = new L.Map(tagName);
        L.control.mousePosition().addTo(lmap);
        var osmUrl = '{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}';
        var osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
        mapData = {
            cacheMaxAge: "30",
            mapDefaultZoom: "{$mapDefaultZoom}",
            mapDefaultLong: "{$mapDefaultX}",
            mapDefaultLat: "{$mapDefaultY}",
            mapMinZoom: "1",
            mapMaxZoom: "25"
        };

        mapFields = {
            'cacheMaxAge': 'cacheMaxAge',
            'mapDefaultZoom': 'mapDefaultZoom',
            'mapDefaultLong': 'mapDefaultLong',
            'mapDefaultLat': 'mapDefaultLat'
        };
        for (var key in mapFields) {
            try {
                var value = Cookies.get(mapFields[key]);
                if (value.length > 0) {
                    mapData[key] = parseFloat(value);
                }
            } catch { }
        }
        //console.log(mapData);
        zoom = 5;
        try {
            if (mapData.mapDefaultZoom > 0) {
                zoom = mapData.mapDefaultZoom;
            }
        } catch { }

        //console.log(mapData);

        osm = new L.TileLayer(osmUrl, {
            minZoom: mapData.mapMinZoom,
            maxZoom: mapData.mapMaxZoom,
            attribution: osmAttrib,
            useCache: true,
            crossOrigin: true,
            cacheMaxAge: mapData["cacheMaxAge"]
        });

        lmap.on("zoomend", function () {
            Cookies.set("mapDefaultZoom", lmap.getZoom(), { expires: 180 });
        });
        lmap.on("moveend", function () {
            var center = lmap.getCenter();
            Cookies.set("mapDefaultLat", center.lat, { expires: 180 });
            Cookies.set("mapDefaultLong", center.lng, { expires: 180 });
        });
        return lmap;
    }
    function mapDisplay(lmap) {
        //console.log(mapData);
        lmap.setView([mapData.mapDefaultLat, mapData.mapDefaultLong], zoom);
        lmap.addLayer(osm);
    }

</script>