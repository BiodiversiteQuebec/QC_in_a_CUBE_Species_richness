if (!exists("pal")) {
    source("data_app.r")
}
ui <- bootstrapPage(
    tags$style(
        type = "text/css",
        "html, body {width:100%;height:100%}"
    ),
    leafletOutput(
        "map",
        width = "100%",
        height = "100%"
    ),
    absolutePanel(
        top = 10,
        right = 10,
        selectInput(
            "datasource",
            "Source des données",
            choices = c("modèles INLA", "cartes eBird", "cartes Boulanger", "données Atlas") #
        ),
        conditionalPanel(
            condition = "input.datasource == 'modèles INLA'",
            sliderTextInput(
                inputId = "year",
                label = "Année",
                choices = as.character(1992:2017),
                selected = "2017",
                grid = TRUE,
                force_edges = TRUE
            )
        ),
        # adding the possibility to display QC polygons
        selectInput(
            "qc_poly",
            "Divisions spatiales",
            choices = list("Aucune",
                "Ecodivisions" = list("Ecozones", "Ecoprovinces", "Ecorégions", "Ecodistricts"),
                "Cadre écologique de référence" = list("Provinces naturelles", "Régions naturelles", "Ensembles physiographiques", "Districts écologiques", "Ensembles topographiques"),
                "Autres" = list("10x10 km")
            ),
            selected = "Aucune"
        )
    )
)

server <- function(input, output, session) {
    # Selected year
    year_obs <- reactive({
        input$year
    })

    # Filtering data for map creation
    filteredData <- reactive({
        if (input$datasource == "cartes Boulanger") {
            boul
        } else if (input$datasource == "cartes eBird") {
            ebird
        } else if (input$datasource == "modèles INLA") {
            path <- paste0("https://object-arbutus.cloud.computecanada.ca/bq-io/acer/ebv/rs_inla/rs_inla_", year_obs(), ".tif")
            print(path)
            map <- rast(path)
        } else if (input$datasource == "données Atlas") {
            path <- "/home/local/USHERBROOKE/juhc3201/BDQC-GEOBON/data/QUEBEC_in_a_cube/Richesse_spe_version_2/data_test/birds_2020.gpkg" # verifier le crs et ne fonctionne pas dans addRasterImage
            print(path)
            map <- st_read(path)
        }
    })

    # Selection of Qc polygons
    qc_poly <- reactive({
        if (input$qc_poly == "Ecozones") {
            ecoz
        } else if (input$qc_poly == "Ecoprovinces") {
            ecop
        } else if (input$qc_poly == "Ecorégions") {
            ecor
        } else if (input$qc_poly == "Ecodistricts") {
            ecod
        } else if (input$qc_poly == "Provinces naturelles") {
            pronat
        } else if (input$qc_poly == "Régions naturelles") {
            regnat
        } else if (input$qc_poly == "Ensembles physiographiques") {
            ensphy
        } else if (input$qc_poly == "Districts écologiques") {
            diseco
        } else if (input$qc_poly == "Ensembles topographiques") {
            enstop
        } else if (input$qc_poly == "10x10 km") {
            pix
        } else if (input$qc_poly == "Aucune") {
            path <- NULL
        }
    })

    # Map visualization
    output$map <- renderLeaflet({
        map <- leaflet() %>%
            addTiles() %>%
            fitBounds(
                lng1 = -79.76332, # st_bbox(qc)[1],
                lat1 = 44.99136, # st_bbox(qc)[2],
                lng2 = -56.93521, # st_bbox(qc)[3],
                lat2 = 62.58192 # st_bbox(qc)[4]
            ) %>%
            addRasterImage(filteredData(), colors = pal, opacity = 0.8) %>%
            addLegend(pal = pal, values = 0:195, title = "Richesse spécifique", position = "bottomright")


        if (!is.null(qc_poly())) {
            map <- map %>%
                addPolygons(
                    data = qc_poly(), weight = 1, color = "white", fillOpacity = 0.1,
                    highlightOptions = highlightOptions(
                        weight = 2,
                        color = "white",
                        fillOpacity = 0.5,
                        bringToFront = TRUE
                    )
                )
        }
        map
    })
}


# else {
#     filteredData <- reactive({
#         if (input$maptype == "Provinces naturelles") {
#             map <- st_read(
#                 "/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL_latlon.gpkg",
#                 query = paste0("SELECT reg_name, X", year_obs(), ", geom FROM QC_CUBE_Richesse_spe_N01_wkt_raw_obs_SIMPL_latlon")
#             )
#         }
#         if (input$maptype == "Régions naturelles") {
#             map <- st_read(
#                 "/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N02_wkt_raw_obs_SIMPL_latlon.gpkg",
#                 query = paste0("SELECT reg_name, X", year_obs(), ", geom FROM QC_CUBE_Richesse_spe_N02_wkt_raw_obs_SIMPL_latlon")
#             )
#         }
#         if (input$maptype == "Niveaux physiographiques") {
#             map <- st_read(
#                 "/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N03_wkt_raw_obs_SIMPL_latlon.gpkg",
#                 query = paste0("SELECT reg_name, X", year_obs(), ", geom FROM QC_CUBE_Richesse_spe_N03_wkt_raw_obs_SIMPL_latlon")
#             )
#         }
#         if (input$maptype == "Districts écologiques") {
#             map <- st_read(
#                 "/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL_latlon.gpkg",
#                 query = paste0("SELECT reg_name, X", year_obs(), ", geom FROM QC_CUBE_Richesse_spe_N04_wkt_raw_obs_SIMPL_latlon")
#             )
#         }
#         if (input$maptype == "10x10 km") {
#             map <- st_read(
#                 "/vsicurl/https://object-arbutus.cloud.computecanada.ca/bq-io/acer/TdeB_benchmark_SDM/TdB_bench_maps/species_richness/raw_obs/QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL_latlon.gpkg",
#                 query = paste0("SELECT ID, X", year_obs(), ", geom FROM QC_CUBE_Richesse_spe_10x10_wkt_raw_obs_SIMPL_latlon")
#             )
#         }

#         names(map)[2] <- "richness"
#         if (input$maptype == "10x10 km") {
#             labels <- sprintf(
#                 "<strong>Pixel # %s</strong></br> Richesse spécifique = %g",
#                 map$ID,
#                 map$richness
#             ) %>%
#                 lapply(htmltools::HTML)
#         } else {
#             labels <- sprintf(
#                 "<strong>%s</strong></br> Richesse spécifique = %g",
#                 map$reg_name,
#                 map$richness
#             ) %>%
#                 lapply(htmltools::HTML)
#         }
#         map$labels <- labels
#         return(map)
#     })

#     output$map <- renderLeaflet({
#         leaflet(qc) %>%
#             addTiles() %>%
#             fitBounds(
#                 lng1 = -79.76332, # st_bbox(qc)[1],
#                 lat1 = 44.99136, # st_bbox(qc)[2],
#                 lng2 = -56.93521, # st_bbox(qc)[3],
#                 lat2 = 62.58192 # st_bbox(qc)[4]
#             ) %>%
#             addLegend(
#                 pal = pal, values = c(0, 195), opacity = 0.7, title = NULL,
#                 position = "bottomright"
#             )
#     })

#     observe({
#         # names(filteredData())[2] <- "richness"
#         leafletProxy("map", data = filteredData()) %>%
#             clearShapes() %>%
#             addPolygons(
#                 fillCol = ~ pal(filteredData()$richness),
#                 weight = .75,
#                 opacity = 1,
#                 color = "grey",
#                 fillOpacity = 0.7,
#                 highlightOptions = highlightOptions(
#                     weight = 1.5,
#                     # color = "black",
#                     fillOpacity = 0.8,
#                     bringToFront = TRUE
#                 ),
#                 label = filteredData()$labels
#             )
#     })
# }

shinyApp(ui = ui, server = server)
