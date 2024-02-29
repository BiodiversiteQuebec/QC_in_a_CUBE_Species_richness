# ================================================================================
# Chargement packages & data
# ================================================================================

#### Packages ####
# -------------- #
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(sf)
library(htmltools)
library(terra)
library(rmapshaper)

pal <- colorNumeric(
    palette = "viridis",
    domain = c(0, 195) # from 0 to max species
)
# ================================================================================
# server
# ================================================================================
server <- function(input, output, session) {
    # -------------------------------- #
    # Richesse specifique - SDM
    # -------------------------------- #

    # -------------------------------- #
    # Richesse specifique - obs brutes
    # -------------------------------- #
    year_rawObs <- reactive({
        input$yearInput_rawObs
    })

    # N01 level map
    output$n01Plot <- renderLeaflet({
        map <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL.gpkg",
            query = paste0("SELECT reg_name, X", year_rawObs(), ", geom FROM QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL")
        )
        names(map)[2] <- "richness"

        labels <- sprintf(
            "<strong>%s</strong></br> Richesse spécifique = %g", map$reg_name, map$richness
        ) %>% lapply(htmltools::HTML)
        leaflet(map) %>%
            addPolygons(
                fillColor = ~ pal(map$richness),
                weight = .01,
                opacity = 1,
                color = "grey",
                fillOpacity = 0.7,
                highlightOptions = highlightOptions(
                    weight = 1.5,
                    color = "black",
                    fillOpacity = 0.7,
                    bringToFront = TRUE
                ),
                label = labels
            )
        # print(m)
    })
    # N02 level map
    output$n02Plot <- renderLeaflet({
        map <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N02_wkt_raw_obs_SIMPL.gpkg",
            query = paste0("SELECT reg_name, X", year_rawObs(), ", geom FROM QC_CUBE_Richesse_spe_N02_wkt_raw_obs_SIMPL")
        )
        names(map)[2] <- "richness"

        pal <- colorNumeric(
            palette = "viridis",
            domain = c(0, 195) # from 0 to max species
        )

        labels <- sprintf(
            "<strong>%s</strong></br> Richesse spécifique = %g", map$reg_name, map$richness
        ) %>% lapply(htmltools::HTML)
        m <- leaflet(map) %>%
            addPolygons(
                fillColor = ~ pal(map$richness),
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
                label = labels
            )
        # print(m)
    })
    # N03 level map
    output$n03Plot <- renderLeaflet({
        map <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N03_wkt_raw_obs_SIMPL.gpkg",
            query = paste0("SELECT reg_name, X", year_rawObs(), ", geom FROM QC_CUBE_Richesse_spe_N03_wkt_raw_obs_SIMPL")
        )
        names(map)[2] <- "richness"

        pal <- colorNumeric(
            palette = "viridis",
            domain = c(0, 195) # from 0 to max species
        )

        labels <- sprintf(
            "<strong>%s</strong></br> Richesse spécifique = %g", map$reg_name, map$richness
        ) %>% lapply(htmltools::HTML)
        m <- leaflet(map) %>%
            addPolygons(
                fillColor = ~ pal(map$richness),
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
                label = labels
            )
        # print(m)
    })
    # N04 level map
    output$n04Plot <- renderLeaflet({
        map <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL.gpkg",
            query = paste0("SELECT reg_name, X", year_rawObs(), ", geom FROM QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL")
        )
        names(map)[2] <- "richness"

        pal <- colorNumeric(
            palette = "viridis",
            domain = c(0, 195) # from 0 to max species
        )

        labels <- sprintf(
            "<strong>%s</strong></br> Richesse spécifique = %g", map$reg_name, map$richness
        ) %>% lapply(htmltools::HTML)
        m <- leaflet(map) %>%
            addPolygons(
                fillColor = ~ pal(map$richness),
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
                label = labels
            )
        # print(m)
    })
    # pix 10x10 km level map
    # ==> need to fix the pb with projection/localisation of pixels

    output$pix10_10Plot <- renderLeaflet({
        map <- st_read("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL.gpkg",
            query = paste0("SELECT ID, X", year_rawObs(), ", geom FROM QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL")
        )
        names(map)[2] <- "richness"
        # map$reg_name <- 1:nrow(map)

        labels <- sprintf(
            "<strong>Pixel # %s</strong></br> Richesse spécifique = %g", map$ID, map$richness
        ) %>% lapply(htmltools::HTML)
        m <- leaflet(map) %>%
            addPolygons(
                fillColor = ~ pal(map$richness),
                weight = .75,
                opacity = 1,
                color = "grey",
                fillOpacity = 0.9,
                highlightOptions = highlightOptions(
                    weight = 1.5,
                    color = "black",
                    fillOpacity = 0.7,
                    bringToFront = TRUE
                ),
                label = labels
            )
    })
}







# ================================================================================
# UI
# ================================================================================
ui <- navbarPage(
    tabPanel(
        "Richesse spécifique - Obs brutes",
        sidebarLayout(
            sidebarPanel(
                # width = 2,
                selectInput(
                    inputId = "yearInput_rawObs",
                    label = "Année",
                    choices = 1990:2019
                )
            ),
            mainPanel(
                # First row
                fluidRow(
                    box(
                        title = "Provinces naturelles",
                        # width = 4,
                        leafletOutput("n01Plot")
                    ),
                    box(
                        title = "Régions naturelles",
                        # width = 4,
                        leafletOutput("n02Plot")
                    ),
                    box(
                        title = "Echelle physiographiques",
                        # width = 4,
                        leafletOutput("n03Plot")
                    )
                ),
                # Third row
                fluidRow(
                    box(
                        title = "Districts écologiques",
                        # width = 4,
                        leafletOutput("n04Plot")
                    ),
                    box(
                        title = "10 x 10 km",
                        # width = 4,
                        leafletOutput("pix10_10Plot")
                    )
                )
            )
        )
    )
)

# ================================================================================
# Lancer l'application
# ================================================================================

shinyApp(ui = ui, server = server)
