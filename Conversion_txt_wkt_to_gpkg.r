#### Conversion des fichiers txt avec RS en fichiers gpkg ####
# --------------------------------------------------------- #

library(terra)
library(sf)
library(plotly)
library(mapview)
library(leaflet)
library(rmapshaper)

mini_occ <- st_read("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/Bellavance_occurrences/total_occ_pres_only_versionR.gpkg", query = "SELECT * FROM total_occ_pres_only_versionR LIMIT 100")
st_crs(mini_occ)
rich <- read.table("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs.txt", sep = "\t", h = T)
rich2 <- read.table("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe/QC_CUBE_Richesse_spe_N02_wkt_raw_obs.txt", sep = "\t", h = T)
head(rich)
names(rich)
queb <- st_read("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_regions/sf_CERQ_SHP/QUEBEC_CR_NIV_02.gpkg")
st_crs(queb)
pix <- st_read("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/QUEBEC_grid_10x10.gpkg")


list_f <- list.files("/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe",
    pattern = "txt",
    full.names = TRUE
)
# Conversion des raw species richness from Narwal in txt with wkt to sf object in gpkg

for (i in list_f[-1]) {
    map <- read.table(i, sep = "\t", h = T)

    if (stringr::str_detect(i, "10x10") == T) {
        rich_sf <- st_as_sf(map,
            wkt = "wkt",
            crs = st_crs(pix)
        )
    } else {
        rich_sf <- st_as_sf(map,
            wkt = "wkt",
            crs = st_crs(mini_occ)
        )
    }
    rich_tr <- st_transform(rich_sf,
        crs = st_crs(4326)
    ) # lat/lon transf for leaflet
    rich_simp <- ms_simplify(rich_tr)

    st_write(
        rich_simp,
        stringr::str_replace(i, ".txt", "_SIMPL_latlon.gpkg")
    )
}
