#### Packages ####
# -------------- #
library(shiny)
library(leaflet)
library(sf)
library(htmltools)
library(terra)
library(RCurl)
library(shinyWidgets)

pal <- colorNumeric(
    palette = "viridis",
    domain = c(0, 195), # from 0 to max species
    na.color = "transparent"
)

# Loading rasters
# ---> Boulanger
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/ebv/rs_Boulanger.tif"
boul <- rast(path)
# ---> eBird
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/ebv/rs_ebird.tif"
ebird <- rast(path)

# Loading vectors
# ---> ecodivisions
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecozones_ll.gpkg"
ecoz <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecoprovinces_ll.gpkg"
ecop <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecoregions_ll.gpkg"
ecor <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecodistricts_ll.gpkg"
ecod <- st_read(path)

# CERQ
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_01_ll.gpkg"
pronat <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_02_ll.gpkg"
regnat <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_03_ll.gpkg"
ensphy <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_04_ll.gpkg"
diseco <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_05_ll.gpkg"
enstop <- st_read(path)
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/qc_grid_1x1km_finale_latlon.gpkg"
pix <- st_read(path)
