#### Test visualisation ####
# ----------------------- #
pix <- st_read("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL_latlon.gpkg")
n4 <- st_read("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL_latlon.gpkg")
n1 <- st_read("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL_latlon.gpkg")

# color palette
# Create a continuous palette function

# CF ==> https://r-graph-gallery.com/183-choropleth-map-with-leaflet.html
pal <- colorNumeric(
    palette = "viridis",
    domain = 0:192
)


labels_pix <- sprintf(
    "<strong>%s</strong></br> Richesse spécifique = %g", pix$ID, pix$X2019
) %>% lapply(htmltools::HTML)
labels_n4 <- sprintf(
    "<strong>%s</strong></br> Richesse spécifique = %g", n4$reg_name, n4$X2019
) %>% lapply(htmltools::HTML)

m <- leaflet() %>%
    addTiles() %>%
    addPolygons(
        data = pix,
        fillColor = ~ pal(X2019),
        weight = .75,
        opacity = 1,
        color = "grey",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
            weight = 1.5,
            color = "black",
            fillOpacity = 0.7,
            bringToFront = TRUE
        ),
        label = labels_pix
    ) %>%
    addPolygons(
        data = n4,
        fillColor = ~ pal(X2019),
        weight = .75,
        opacity = 1,
        color = "grey",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
            weight = 1.5,
            color = "black",
            fillOpacity = 0.7,
            bringToFront = TRUE
        ),
        label = labels_n4
    )
m


mapview(rich_sf)

plot(rich_sf$X1990)

plot_ly(rich_sf)
mapview(rich_sf, zcol = "X2019")
mapview(rich_sf, zcol = "X2010")
leaflet(rich_sf) %>% addPolygons(st_geometry(rich_sf), color = "green")

test <- read.table("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs.txt", sep = "\t", h = T)
head(test)

#### Test pour visualisation ####
# ---------------------------- #
library(sf)
library(leaflet)
library(mapview)

niv1 <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL.gpkg",
    query = "SELECT reg_name, X2000, geom FROM QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL"
)

niv2 <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N02_wkt_raw_obs_SIMPL.gpkg",
    query = "SELECT reg_name, X2000, geom FROM QC_CUBE_Richesse_spe_N02_wkt_raw_obs_SIMPL"
)

niv3 <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N03_wkt_raw_obs_SIMPL.gpkg",
    query = "SELECT reg_name, X2000, geom FROM QC_CUBE_Richesse_spe_N03_wkt_raw_obs_SIMPL"
)

niv4 <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL.gpkg",
    query = "SELECT reg_name, X2000, geom FROM QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL"
)

nivPix <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL.gpkg",
    query = "SELECT ID, X2000, geom FROM QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL"
)
# Creating a leaflet object with points and polygons

leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    #   addCircleMarkers(lng=quakes$long,
    #                    lat=quakes$lat,
    #                    col="blue",
    #                    radius=3,
    #                    stroke=FALSE,
    #                    fillOpacity = 0.7,
    #                    #options = markerOptions(minZoom=15, maxZoom=20), # Oldcode
    #                    group = "Quake Points") %>%                       # Newcode
    addPolygons(
        data = niv1,
        col = "red",
        group = "niv1"
    ) %>%
    addPolygons(
        data = niv2,
        col = "blue",
        group = "niv2"
    ) %>%
    addPolygons(
        data = niv3,
        col = "green",
        group = "niv3"
    ) %>%
    addPolygons(
        data = niv4,
        col = "orange",
        group = "niv4"
    ) %>%
    addPolygons(
        data = nivPix,
        col = "yellow",
        group = "nivPix"
    ) %>%
    groupOptions("niv2", zoomLevels = 17:18) %>%
    groupOptions("niv3", zoomLevels = 18:19) %>%
    groupOptions("niv4", zoomLevels = 19:20) %>%
    groupOptions("nivPix", zoomLevels = 20:21)
