#### Packages ####
# -------------- #
library(shiny)
library(leaflet)
library(sf)
library(htmltools)
library(terra)
library(RCurl)
library(shinyWidgets)

# Loading rasters
# ---> Boulanger
path <- "/vsicurl_streaming/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/ebv/rs_Boulanger_cog.tif"
boul <- rast(path)
# ---> eBird
path <- "/vsicurl_streaming/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/ebv/rs_ebird_cog.tif"
ebird <- rast(path)

# Loading vectors
# ---> ecodivisions
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecozones_ll.gpkg"
ecoz <- st_read(path)
names(ecoz)[4] <- "ID"
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecoprovinces_ll.gpkg"
ecop <- st_read(path)
names(ecop)[4] <- "ID"
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecoregions_ll.gpkg"
ecor <- st_read(path)
names(ecor)[4] <- "ID"
path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_eco_poly/qc_ecodistricts_ll.gpkg"
ecod <- st_read(path)
names(ecod)[4] <- "ID"

### !!!!! voir la concordance des IDs avec ce qui a été utilisé dans narval

# CERQ
# path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_01_ll.gpkg"
# pronat <- st_read(path)
# path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_02_ll.gpkg"
# regnat <- st_read(path)
# path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_03_ll.gpkg"
# ensphy <- st_read(path)
# path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_04_ll.gpkg"
# diseco <- st_read(path)
# path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/sf_CERQ_SHP/QUEBEC_CR_NIV_05_ll.gpkg"
# enstop <- st_read(path)
# path <- "https://object-arbutus.cloud.computecanada.ca/bq-io/acer/qc_polygons/qc_grid_1x1km_finale_latlon.gpkg"
# pix <- st_read(path)

# RS trends
eco_rs <- read.table("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/ebv/data/ecopolygons_rs.txt")

#### Blank map when rs map does not exist ####
bb <- st_bbox(ecoz)

ref_ras <- rast(
    xmin = bb[1],
    xmax = bb[3],
    ymin = bb[2],
    ymax = bb[4],
    resolution = 10000
)
crs(ref_ras) <- "epsg:32198"
values(ref_ras) <- 1
ref_ras_ll <- terra::project(ref_ras, "epsg:4326")
