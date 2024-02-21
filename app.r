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

#### remote data ####
# ---------------- #
# rs_n01 <- read.table("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N01_wkt_raw_obs.txt", sep = "\t", h = T) # impossible to load
rs_n02 <- read.table("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N02_wkt_raw_obs.txt", sep = "\t", h = T)
rs_n03 <- read.table("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N03_wkt_raw_obs.txt", sep = "\t", h = T)
rs_n04 <- read.table("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N04_wkt_raw_obs.txt", sep = "\t", h = T)
rs_pix_10x10 <- read.table("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs.txt", sep = "\t", h = T)

# ================================================================================
# server
# ================================================================================
server <- function(input, output, session) {
    # -------------------------------- #
    # Richesse specifique - SDM
    # -------------------------------- #

    #### Map selection
    observeEvent(input$predictors, {
        if (input$rs_predictors == "noPredictors") {
            updateRadioGroupButtons(session, "rs_spatial", choices = "Spatial")
        } else {
            updateRadioGroupButtons(session, "rs_spatial", choices = c("Spatial", "noSpatial"))
        }
    })

    # eBird
    # path_RS_ebird <- reactive({
    #     paste0(input$species_select, "_range.tif")
    # })

    # Vincent - INLA
    output$rs_INLA <- renderPlot({
        map <- rast("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/RICH_SPE_INLA_RS_2017.tif")

        plot(map,
            axes = F,
            mar = NA,
            main = "Richesse spécifique"
        )
        plot(st_geometry(qc),
            add = T,
            border = "grey"
        )
        plot(st_geometry(lakes_qc),
            add = T,
            col = "white",
            border = "grey"
        )
    })

    # Maxent
    path_RS_Maxent <- reactive({
        paste0("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/RICH_SPE_Maxent_", input$rs_predictors, "_", input$rs_bias, "_", input$rs_spatial, "_2017.tif")
    })
    output$rs_maxent <- renderPlot({
        map <- rast(path_RS_Maxent())

        plot(map,
            axes = F,
            mar = NA,
            # range = c(0, 1),
            main = "Richesse spécifique"
        )
        plot(st_geometry(qc),
            add = T,
            border = "grey"
        )
        plot(st_geometry(lakes_qc),
            add = T,
            col = "white",
            border = "grey"
        )
    })

    # MapSpecies
    path_RS_mapSpecies <- reactive({
        paste0("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/RICH_SPE_ewlgcpSDM_", input$rs_predictors, "_", input$rs_bias, "_", input$rs_spatial, "_2017.tif")
    })
    output$rs_mapSPecies <- renderPlot({
        map <- rast(path_RS_mapSpecies())

        plot(map,
            axes = F,
            mar = NA,
            # range = c(0, 1),
            main = "Richesse spécifique"
        )
        plot(st_geometry(qc),
            add = T,
            border = "grey"
        )
        plot(st_geometry(lakes_qc),
            add = T,
            col = "white",
            border = "grey"
        )
    })
    # BRT
    path_RS_brt <- reactive({
        paste0("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/RICH_SPE_brt_", input$rs_predictors, "_", input$rs_bias, "_", input$rs_spatial, "_2017.tif")
    })
    output$rs_brt <- renderPlot({
        map <- rast(path_RS_brt())

        plot(map,
            axes = F,
            mar = NA,
            # range = c(0, 1),
            main = "Richesse spécifique"
        )
        plot(st_geometry(qc),
            add = T,
            border = "grey"
        )
        plot(st_geometry(lakes_qc),
            add = T,
            col = "white",
            border = "grey"
        )
    })

    # Random Forest
    path_RS_randomForest <- reactive({
        paste0("/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/RICH_SPE_randomForest_", input$rs_predictors, "_", input$rs_bias, "_", input$rs_spatial, "_2017.tif")
    })
    output$rs_rf <- renderPlot({
        map <- rast(path_RS_randomForest())

        plot(map,
            axes = F,
            mar = NA,
            # range = c(0, 1),
            main = "Richesse spécifique"
        )
        plot(st_geometry(qc),
            add = T,
            border = "grey"
        )
        plot(st_geometry(lakes_qc),
            add = T,
            col = "white",
            border = "grey"
        )
    })

    # -------------------------------- #
    # Richesse specifique - obs brutes
    # -------------------------------- #
    year_rawObs <- reactive({
        input$yearInput_rawObs
    })

    # N01 level map
    output$n01Plot <- renderLeaflet({

    })
    # N02 level map
    # N03 level map
    # N04 level map
    # pix 10x10 km level map
}












# ================================================================================
# UI
# ================================================================================
ui <- navbarPage(
    tabPanel(
        "Richesse spécifique - SDM",
        sidebarLayout(
            sidebarPanel(
                width = 2,
                radioGroupButtons("rs_predictors",
                    label = "Prédicteurs environnementaux",
                    choices = c("Predictors", "noPredictors")
                ),
                radioGroupButtons("rs_bias",
                    label = "Biais d'échantillonnage",
                    choices = c("Bias", "noBias")
                ),
                radioGroupButtons("rs_spatial",
                    label = "Auto-corrélation spatiale",
                    choices = c("Spatial", "noSpatial")
                )
            ),
            mainPanel(
                # First row
                fluidRow(
                    box(
                        title = "e-bird",
                        width = 4,
                        status = "primary",
                        plotOutput("")
                    ),
                    box(
                        title = "mapSpecies",
                        width = 4,
                        status = "warning",
                        plotOutput("rs_mapSPecies")
                    ),
                    box(
                        title = "Maxent",
                        width = 4,
                        status = "warning",
                        plotOutput("rs_maxent")
                    )
                ),
                # Third row
                fluidRow(
                    box(
                        title = "INLA",
                        width = 4,
                        status = "primary",
                        plotOutput("rs_INLA")
                    ),
                    box(
                        title = "boosted regression tree",
                        width = 4,
                        status = "warning",
                        plotOutput("rs_brt")
                    ),
                    box(
                        title = "random forest",
                        width = 4,
                        status = "warning",
                        plotOutput("rs_rf")
                    )
                )
            )
        )
    ),
    tabPanel(
        "Richesse spécifique - Obs brutes",
        sidebarLayout(
            sidebarPanel(
                width = 2,
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
                        width = 4,
                        leafletOutput("n01Plot")
                    ),
                    box(
                        title = "Régions naturelles",
                        width = 4,
                        leafletOutput("n02Plot")
                    ),
                    box(
                        title = "Echelle physiographiques",
                        width = 4,
                        leafletOutput("n03Plot")
                    )
                ),
                # Third row
                fluidRow(
                    box(
                        title = "Districts écologiques",
                        width = 4,
                        leafletOutput("n04Plot")
                    ),
                    box(
                        title = "10 x 10 km",
                        width = 4,
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
