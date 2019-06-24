library(shiny)
library(rsconnect)
library(ggplot2)
library(ggradar)
library(gridExtra)
library(corrplot)
library(DT)
library(readr)
library(leaflet)
library(dplyr)
library(scales)

college_map_df <- read.csv("college_map.csv")
admission <- read.csv("Admission_Predict_Ver1.1.csv")
admission$Serial.No. <- as.factor(admission$Serial.No.)
admission$University.Rating <- as.factor(admission$University.Rating)
admission$Research <- as.factor(admission$Research)

server <- function(input, output) {
  output$college_map <- renderLeaflet({
    leaflet(data = college_map_df) %>% 
      addTiles() %>%
      addMarkers(~long, ~lat, popup = paste("<strong>Name: </strong>", college_map_df$name, "<br>",
                                            "<strong>Ranking: </strong>", college_map_df$ranking, "<br>",
                                            "<strong>Tuition: </strong>", college_map_df$tuition, "<br>",
                                            "<strong>Acceptance Rate: </strong>", college_map_df$acceptance_rate, "<br>",
                                            "<strong>Graduation Rate: </strong>", college_map_df$graduation_rate, "<br>",
                                            "<strong>Median Earnings 6 Years After Graduation: </strong>", college_map_df$salary, "<br>"))
  })
  output$data_describe <- renderPrint({
    str(admission)
  })
  
  output$histogram_plot <- renderPlot({
    #Plot 1: GRE.Score
    g1 <- ggplot(admission, aes(admission$GRE.Score))
    g1 <- g1 + geom_histogram(binwidth = .5, fill="green", color = "black",alpha = .2)
    g1 <- g1 + geom_vline(aes(xintercept = mean(admission$GRE.Score)), colour="red", size=2, alpha=.6)
    g1 <- g1 + labs(x = "GRE.Score")
    g1 <- g1 + labs(y = "Frequency")
    g1 <- g1 + labs(title = paste("Distribution of GRE.Score, mean =", round(mean(admission$GRE.Score),2)))
    
    #Plot 2: TOEFL.Score
    g2 <- ggplot(admission, aes(admission$TOEFL.Score))
    g2 <- g2 + geom_histogram(binwidth = .5, fill="green", color = "black",alpha = .2)
    g2 <- g2 + geom_vline(aes(xintercept = mean(admission$TOEFL.Score)), colour="red", size=2, alpha=.6)
    g2 <- g2 + labs(x = "TOEFL.Score")
    g2 <- g2 + labs(y = "Frequency")
    g2 <- g2 + labs(title = paste("Distribution of TOEFL.Score, mean =", round(mean(admission$TOEFL.Score),2)))
    
    #Plot 3: SOP
    g3 <- ggplot(admission, aes(admission$SOP))
    g3 <- g3 + geom_histogram(binwidth = .5, fill="yellow", color = "black",alpha = .2)
    g3 <- g3 + geom_vline(aes(xintercept = mean(admission$SOP)), colour="red", size=2, alpha=.6)
    g3 <- g3 + labs(x = "SOP")
    g3 <- g3 + labs(y = "Frequency")
    g3 <- g3 + labs(title = paste("Distribution of SOP, mean =", round(mean(admission$SOP),2)))
    
    #Plot 4: LOR
    g4 <- ggplot(admission, aes(admission$LOR))
    g4 <- g4 + geom_histogram(binwidth = .5, fill="yellow", color = "black",alpha = .2)
    g4 <- g4 + geom_vline(aes(xintercept = mean(admission$LOR)), colour="red", size=2, alpha=.6)
    g4 <- g4 + labs(x = "LOR")
    g4 <- g4 + labs(y = "Frequency")
    g4 <- g4 + labs(title = paste("Distribution of LOR, mean =", round(mean(admission$LOR),2)))
    
    #Plot 5: CGPA
    g5 <- ggplot(admission, aes(admission$CGPA))
    g5 <- g5 + geom_histogram(binwidth = .5, fill="yellow", color = "black",alpha = .2)
    g5 <- g5 + geom_vline(aes(xintercept = mean(admission$CGPA)), colour="red", size=2, alpha=.6)
    g5 <- g5 + labs(x = "CGPA")
    g5 <- g5 + labs(y = "Frequency")
    g5 <- g5 + labs(title = paste("Distribution of CGPA, mean =", round(mean(admission$CGPA),2)))
    
    #Plot 6: University.Rating
    g6 <- ggplot(admission, aes(admission$University.Rating))
    g6 <- g6 + geom_bar()
    g6 <- g6 + labs(x = "University.Rating")
    g6 <- g6 + labs(y = "Frequency")
    
    #Plotting 6 graphs
    grid.arrange(g1,g2,g3,g4,g5,g6,nrow=3, ncol=2)
  })
  output$histogram_factor_plot <- renderPlot({
    attribute2 <- input$xaxis2
    ggplot(admission, aes_string( x = attribute2 ,fill = factor(admission$Research), color = factor(admission$Research)))+
      geom_histogram( alpha=0.5, position="identity")+ 
      scale_color_brewer(palette= "Paired")+ 
      scale_fill_brewer(palette="Paired")+
      theme(legend.position="top")+
      theme_classic()
  })
  output$scatter_plot <- renderPlot({
    attribute <- input$xaxis
    ggplot(data=admission) +   
      geom_point(aes_string(x=attribute,  
                            y=admission$Chance.of.Admit)) + 
      geom_smooth(aes_string(x=attribute,
                             y=admission$Chance.of.Admit)) +
      labs(title="Scatter of Attribute-Chance of Admit",
           x=attribute,
           y="Chance.of.Admit") +
      theme_bw()
    
  })
  output$scatter_factor_plot <- renderPlot({
    x_attribute <- input$xaxis3
    print(x_attribute)
    x_factor <- input$factor
    print(x_factor)
    ggplot(admission, aes_string(x= x_attribute, y = admission$Chance.of.Admit, color = x_factor)) + 
      theme_minimal()+
      geom_point()
  })
  output$radar_plot <- renderPlot({
    suppressPackageStartupMessages(library(dplyr))
    ad_data <- read.csv("Admission_Predict_Ver1.1.csv")
    for (row in 1:nrow(ad_data)){
      if (ad_data$Chance.of.Admit[row] >= 0.7){
        ad_data$type[row] <- "high"
      } else if (0.7 > ad_data$Chance.of.Admit[row] && ad_data$Chance.of.Admit[row] >= 0.5){
        ad_data$type[row] <- "median"
      } else {
        ad_data$type[row] <- "low"
      }
    }
    
    ad_data <- ad_data[,c(-9)]
    
    new_ad_data <- ad_data %>%
      group_by(type) %>%
      mutate_each(funs(rescale)) %>%
      summarise(mean(GRE.Score), mean(TOEFL.Score), mean(University.Rating), mean(SOP),
                mean(LOR), mean(CGPA), mean(Research))
    ggradar(new_ad_data)
  })
  
  output$box_factor_plot <- renderPlot({
    x_factor_2 <- input$factor2
    ggplot(admission, aes_string(x= x_factor_2 , y=admission$Chance.of.Admit, fill = x_factor_2)) +
      geom_boxplot()+
      theme_minimal()
  })
  
  regression_dat <- data.frame(
    model_name = c('linear_regression', 'random_forest', 'decision_tree', 'support_vector_regression', 'ridge_regression'),
    train_r2_score = c('0.821', '0.968', '1.0', '0.874', '0.821'),
    test_r2_score = c('0.819', '0.891', '0.578', '0.852', '0.819'),
    train_RMSE = c('0.003', '0.001', '0.002', '0.001', '0.004'),
    test_RMSE = c('0.004', '0.002', '0.01', '0.003', '0.005'), 
    train_MAE = c('0.023', '0.017', '0.03', '0.02', '0.043'),
    test_MAE = c('0.033', '0.024', '0.065', '0.031', '0.046'),
    flag = c('<img src="linear_regression.png" height="200"></img>',
             '<img src="random_forest.png" height="200"></img>',
             '<img src="decision_tree.png" height="200"></img>',
             '<img src="support_vector_regression.png" height="200"></img>',
             '<img src="ridge_regression.png" height="200"></img>'
             )
  )
  
  output$regression_table <- DT::renderDataTable({
    DT::datatable(regression_dat, escape = FALSE)  
  })
  
  confusion_dat <- data.frame(
    model_name = c('logistic_regression', 'support_vector_machine', 'gaussian_naive_bayes', 'decision_tree', 'random_forest'),
    accuracy_score = c('0.92', '0.95', '0.87', '0.95', '0.95'),
    precision_score = c('0.833', '0.818', '0.48', '0.733', '0.769'),
    recall_score = c('0.417', '0.75', '1.0', '0.916', '0.833'),
    f1_score = c('0.555', '0.783', '0.649', '0.815', '0.8'),
    flag = c('<img src="logistic_regression_classification.png" height="200"></img>',
             '<img src="support_vector_machine_classification.png" height="200"></img>',
             '<img src="gaussian_naive_bayes_classification.png" height="200"></img>',
             '<img src="decision_tree_classification.png" height="200"></img>',
             '<img src="random_forest_classification.png" height="200"></img>'
             )
    )
    
  output$classification_table <- DT::renderDataTable({
    DT::datatable(confusion_dat, escape = FALSE)  
  })
  
}

