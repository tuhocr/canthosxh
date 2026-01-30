library(shiny)
library(sf)
library(plotly)
library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(ggExtra)
library(tidyverse)
library(gsheet)
library(shinydashboard)
library(kableExtra)
library(dashboardthemes)
library(leaflet)
library(leaflet.extras)
library(htmltools)
library(shinydashboardPlus)
library(readxl)
library(lubridate)
library(listviewer)
library(viridisLite)
library(shinyWidgets)

# khi deploy trên linux, cần cài đủ package

#### LOAD DATASET ####


if(Sys.info()['sysname'] == "Windows"){
  
  SXH_YEAR_2025 <- readRDS("SXH_YEAR_2025.rds")
  SXH_YEAR_2026 <- readRDS("SXH_YEAR_2026.rds")
  df <- rbind(SXH_YEAR_2025, SXH_YEAR_2026)
  
} else {
  
  SXH_YEAR_2025 <- readRDS("/home/rp1/Documents/canthosxh/CLEAN_DATA_OUTPUT/SXH_YEAR_2025.rds")
  SXH_YEAR_2026 <- readRDS("/home/rp1/Documents/canthosxh/CLEAN_DATA_OUTPUT/SXH_YEAR_2026.rds")
  df <- rbind(SXH_YEAR_2025, SXH_YEAR_2026)
  
}

df <- as.data.frame(df)

if(Sys.info()['sysname'] == "Windows"){
  
  cantho_v1 <- readRDS("cantho_sf.rds")
  
} else {
  
  cantho_v1 <- readRDS("/home/rp1/Documents/canthosxh/cantho_sf.rds")
  # cantho_v1 <- readRDS("/home/rp1/Documents/canthosxh/cantho_SHP.rds")
  
}

cantho_small <- cantho_v1[ , c(13, 2, 9)]

setdiff(df$PHUONG_XA_MOI, cantho_small$ten_xa)
setdiff(cantho_small$ten_xa, df$PHUONG_XA_MOI)

df <- df[ , 1:4]

df$NGAY_VV <- as.Date(df$NGAY_VV)



#### CHUAN COT DATE ####

range(df$NGAY_VV)[1] -> date_ori

lubridate:::year(date_ori) -> year_num

date_ori_min <- paste0(year_num, "-01-01")

date_ori_min  <- as.Date(date_ori_min)

date_ori_max <- paste0(year_num, "-12-31")

date_ori_max  <- as.Date(date_ori_max)

#### SETUP UI ####



##### HEADER #####

header_img <- div(
  class = "my-title",
  h2(''),
  tags$style(".my-title :is(h2){color: white; font-weight: bold;
               font-family: 'Arial';
               position: absolute;
               bottom:0px;
               left: 50px}")
  
)

header_chuan <-  htmltools::tagQuery(shinydashboardPlus:::dashboardHeader(title = HTML('Cần Thơ'),
                                                                          titleWidth = 150,
                                                                          controlbarIcon = NULL,
                                                                          leftUi = tagList(
                                                                            # dropMenu(
                                                                            #   label = HTML('<a href="https://tuhocr.github.io/canthosxh/"><span style="color:yellow;">Cần Thơ</span></a>'),
                                                                            #   # status = "primary",
                                                                            #   circle = FALSE
                                                                            # )
                                                                            dropMenu(
                                                                              actionButton(inputId = "menu_1", 
                                                                                           disabled = FALSE,
                                                                                           onclick = "window.open('https://tuhocr.github.io/canthosxh/')",
                                                                                           label = HTML('<span style="color:white;"><b>Tổng hợp<b></span>')),
                                                                              hideOnClick = FALSE,
                                                                              trigger = "click",
                                                                              options = dropMenuOptions(duration = c(0, 0),
                                                                                                        animation = "none",
                                                                                                        flip = FALSE,
                                                                                                        placement = "right",
                                                                                                        delay = 100000000)
                                                                              
                                                                             
                                                                          )
                                                                          )
)
                                     )

header_chuan <- header_chuan$
  find(".navbar.navbar-static-top")$ 
  append(header_img)$ 
  allTags()



##### NAVBAR #####



##### SIDEBAR #####

sidebar_chuan <- shinydashboard:::dashboardSidebar(
  
  width = 150,
  
  sidebarMenu(
    
    menuItem("SXH",
             tabName = "sb_stats", 
             icon = icon("dashboard"))
    
    # menuItem("Fire spot", 
    #          tabName = "fire_spot",
    #          icon = icon("fire"))
    
    
  ))

##### BODY #####

body_chuan <-   dashboardBody(
  
  shinyDashboardThemes(theme = "flat_red"),
  
  
  tabItems(
    
    tabItem(tabName = "sb_stats",
            
            fluidRow(
              tabBox(
                
                width = 12,
                
                id = "tabset1", 
                
                tabPanel(title = "Thống kê",
                         
                         fluidRow(shinydashboard:::box(dateRangeInput(inputId = "extract_date_1",
                                                                      label = HTML('<span style="color:black;">Chọn thời gian</span>'),
                                                                      start = date_ori_min,
                                                                      end = date_ori_max),
                                                       actionButton("run1", "Compute"),
                                                       width = NULL,
                                                       height = NULL)),
                         
                         
                         fluidRow(shinydashboard:::box(plotlyOutput(outputId = "p1"),
                                                       width = NULL,
                                                       height = NULL))),
                
                tabPanel(title = "Tháng",
                         
                         fluidRow(shinydashboard:::box(selectInput(
                           inputId = "select_month",
                           label = HTML('<span style="color:black;">Chọn tháng</span>'),
                           choices = list("Tháng 1" = "1", 
                                          "Tháng 2" = "2",
                                          "Tháng 3" = "3",
                                          "Tháng 4" = "4",
                                          "Tháng 5" = "5",
                                          "Tháng 6" = "6",
                                          "Tháng 7" = "7",
                                          "Tháng 8" = "8",
                                          "Tháng 9" = "9",
                                          "Tháng 10" = "10",
                                          "Tháng 11" = "11",
                                          "Tháng 12" = "12"
                           ),
                           selected = "1"
                         ),
                         actionButton("run2", "Compute"),
                         width = NULL,
                         height = NULL)),
                         
                         
                         fluidRow(shinydashboard:::box(plotlyOutput(outputId = "p2"),
                                                       width = NULL,
                                                       height = NULL)))
              )
              
              
            )
            
            
    )))

##### UI  #####

ui <- shinydashboard:::dashboardPage(
  
  # shinydashboard:::dashboardHeader(),
  header_chuan,
  
  
  # shinydashboard:::dashboardSidebar(),
  sidebar_chuan,
  
  # shinydashboard:::dashboardBody()
  body_chuan
  
)

#### SERVER ####

server <- function(input, output) {
  
  #ĐỒ THỊ TỔNG SỐ CA TRONG NĂM THEO KHU VỰC
  output$p1 <- renderPlotly({
    
    #debug
    # plot_ly(mtcars, y = ~mpg, color = I("black"), 
    #         alpha = 0.1, boxpoints = "suspectedoutliers")
    
    #TRÍCH THEO NGÀY
    
    df_SXH <- df |> subset(NGAY_VV >= as.Date("2025-05-22") &
                             NGAY_VV <=  as.Date("2025-07-14"))
    
    df_SXH <- df |> subset(NGAY_VV >= input$extract_date_1[1] &
                             NGAY_VV <= input$extract_date_1[2])
    
    table(df_SXH$TTYTKV,
          df_SXH$PHUONG_XA_MOI,
          df_SXH$NGAY_VV) -> stat_day
    
    as.data.frame(stat_day) -> stat_day_df
    
    names(stat_day_df) <- c("TTYTKV", "PHUONG_XA_MOI", "NGAY_VV", "COUNT")
    
    stat_day_df$TTYTKV <- as.character(stat_day_df$TTYTKV)
    
    stat_day_df$PHUONG_XA_MOI <- as.character(stat_day_df$PHUONG_XA_MOI)
    
    stat_day_df$NGAY_VV <- as.character(stat_day_df$NGAY_VV)
    
    stat_day_df$NGAY_VV <- as.Date(stat_day_df$NGAY_VV)
    
    stat_day_df |> dplyr:::arrange(desc(TTYTKV),
                                   desc(PHUONG_XA_MOI),
                                   desc(NGAY_VV))  -> stat_day_df_final
    
    stat_day_df <- stat_day_df |> subset(COUNT != 0)
    
    stat_day_df -> stat_day_df_DAY_ORI
    
    time_1 <- paste0("Từ ngày ",
                     as.character(range(stat_day_df$NGAY_VV)[1]),
                     " đến ngày ",
                     as.character(range(stat_day_df$NGAY_VV)[2]))
    
    stat_day_df |> dplyr:::group_by(TTYTKV, PHUONG_XA_MOI) |>
      dplyr:::summarise(TONG_SO_CA = sum(COUNT)) |> dplyr:::arrange(TTYTKV, desc(TONG_SO_CA), PHUONG_XA_MOI) |>
      as.data.frame() -> total_case_day
    
    total_case_day -> total_case_day_YEAR_ORI
    
    names(total_case_day)[2] <- "ten_xa"
    
    cantho_ok <- merge(x = cantho_small,
                       y = total_case_day,
                       all = TRUE,
                       by = "ten_xa")
    
    
    paste0("\nTổng số ca SXH trong tỉnh Cần Thơ (",
           sum(total_case_day$TONG_SO_CA),
           " ca)\n",
           time_1 , "\n\n") -> total_case
    
    
    cantho_ok$text_chuan <- NA
    
    for(i in 1:nrow(cantho_ok)){
      
      if(!is.na(cantho_ok$TONG_SO_CA[i]))  {
        
        cantho_ok$text_chuan[i] <- paste0(cantho_ok$ten_xa[i], 
                                          "\n", 
                                          cantho_ok$TONG_SO_CA[i], 
                                          " ca SXH")
      } else {
        
        cantho_ok$text_chuan[i] <- paste0(cantho_ok$ten_xa[i], 
                                          "\n", 
                                          "Không có ca SXH")  
        
      }
      
    }
    
    
    # withProgress(message = 'Đang xử lý dữ liệu',
    #              detail = 'Vui lòng chờ trong giây lát...', value = 0, {
    #                for (i in 1:15) {
    #                  incProgress(1/15)
    #                  Sys.sleep(0.25)
    #                }
    #              })
    
    cantho_ok -> cantho_bug
    cantho_bug$ten_xa[cantho_bug$ten_xa == "Mỹ Qưới"] <- "Mỹ Quới"
    sort(table(cantho_bug$ten_xa))
    
    cantho_bug |> dplyr:::group_by(ten_xa) |> dplyr:::summarise(TONG_SO_CA = sum(TONG_SO_CA)) -> cantho_bug_fix
    
    sort(table(cantho_bug_fix$ten_xa))
    plot_ly(cantho_ok) 
    plot_ly(cantho_bug)
    
  
    
    plot_ly(cantho_bug_fix)
  }) |>
    bindEvent(input$run1)
  
  
  
  #ĐỒ THỊ TỔNG SỐ CA TRONG NĂM THEO THÁNG
  output$p2 <- renderPlotly({
    
    #debug
    # plot_ly(mtcars, y = ~mpg, color = I("black"), 
    #         alpha = 0.1, boxpoints = "suspectedoutliers")
    
    #TRÍCH THEO THÁNG
    
    
    df$THANG_VV <- lubridate::month(df$NGAY_VV)
    
    df_SXH  <- df |> subset(THANG_VV == input$select_month) 
    
    table(df_SXH$TTYTKV,
          df_SXH$PHUONG_XA_MOI,
          df_SXH$NGAY_VV) -> stat_day
    
    as.data.frame(stat_day) -> stat_day_df
    
    names(stat_day_df) <- c("TTYTKV", "PHUONG_XA_MOI", "NGAY_VV", "COUNT")
    
    stat_day_df$TTYTKV <- as.character(stat_day_df$TTYTKV)
    
    stat_day_df$PHUONG_XA_MOI <- as.character(stat_day_df$PHUONG_XA_MOI)
    
    stat_day_df$NGAY_VV <- as.character(stat_day_df$NGAY_VV)
    
    stat_day_df$NGAY_VV <- as.Date(stat_day_df$NGAY_VV)
    
    stat_day_df |> dplyr:::arrange(desc(TTYTKV),
                                   desc(PHUONG_XA_MOI),
                                   desc(NGAY_VV))  -> stat_day_df_final
    
    stat_day_df <- stat_day_df |> subset(COUNT != 0)
    
    stat_day_df -> stat_day_df_DAY_ORI
    
    time_1 <- paste0("Từ ngày ",
                     as.character(range(stat_day_df$NGAY_VV)[1]),
                     " đến ngày ",
                     as.character(range(stat_day_df$NGAY_VV)[2]))
    
    stat_day_df |> dplyr:::group_by(TTYTKV, PHUONG_XA_MOI) |>
      dplyr:::summarise(TONG_SO_CA = sum(COUNT)) |> dplyr:::arrange(TTYTKV, desc(TONG_SO_CA), PHUONG_XA_MOI) |>
      as.data.frame() -> total_case_day
    
    total_case_day -> total_case_day_YEAR_ORI
    
    names(total_case_day)[2] <- "ten_xa"
    
    cantho_ok <- merge(x = cantho_small,
                       y = total_case_day,
                       all = TRUE,
                       by = "ten_xa")
    
    
    paste0("\nTổng số ca SXH trong tỉnh Cần Thơ (",
           sum(total_case_day$TONG_SO_CA),
           " ca)\n",
           time_1 , "\n\n") -> total_case
    
    cantho_ok$text_chuan <- NA
    
    for(i in 1:nrow(cantho_ok)){
      
      if(!is.na(cantho_ok$TONG_SO_CA[i]))  {
        
        cantho_ok$text_chuan[i] <- paste0(cantho_ok$ten_xa[i], 
                                          "\n", 
                                          cantho_ok$TONG_SO_CA[i], 
                                          " ca SXH")
      } else {
        
        cantho_ok$text_chuan[i] <- paste0(cantho_ok$ten_xa[i], 
                                          "\n", 
                                          "Không có ca SXH")  
        
      }
      
    }
    
    withProgress(message = 'Đang xử lý dữ liệu',
                 detail = 'Vui lòng chờ trong giây lát...', value = 0, {
                   for (i in 1:15) {
                     incProgress(1/15)
                     Sys.sleep(0.25)
                   }
                 })
    
    plot_ly(cantho_ok[ , ],
            split = ~ten_xa,
            color = ~TONG_SO_CA,
            # colors = c("lightyellow", "red"),
            # colors = rev(viridisLite::inferno(20)),
            colors = rev(viridisLite::viridis(20)),
            # text = ~paste0(ten_xa, "\n", TONG_SO_CA, " ca SXH"),
            text = ~text_chuan,
            hoveron = "fills",
            hoverinfo = "text",
            hoverlabel = list(bgcolor = "white"),
            stroke = I("black"),
            span = I(0.5),
            width = 600,
            height = 600) %>% 
      
      layout(showlegend = FALSE,
             title = total_case
      )  %>% colorbar(title = '<span style="color:red;"><b>Số lượng</b></span>')
    
  }) |>
    bindEvent(input$run2)
  
  
  
  
  
  
  
  
  
}

#### RUN ####

shinyApp(ui = ui, server = server)


# https://plotly-r.com/controlling-tooltips
# https://community.plotly.com/t/adding-alpha-to-hover-in-r-can-it-be-done/56126/2
# https://jackolney.github.io/posts/2016-04-01-shiny/
# https://www.tilburgsciencehub.com/topics/visualization/data-visualization/dashboarding/shinydashboard/
# https://rinterface.github.io/shinydashboardPlus/articles/enhanced-header.html








