#Loading all necessary libraries

library(shiny)
library(plotly)
library(dplyr)
library(shinythemes)
library(shinyWidgets)
library(ggrepel)
library(tidyverse)

#Load data from the rds

data <- read_rds("NHL_data.rds")

#creating the options for my drop down menu


# Define UI

ui <- navbarPage(
  "NHL Stats in Correlation to Goals Scored",
  
  #creating a tab for all statistics that occur during a game
  tabPanel("On Ice Stats",
  
  fluidPage(theme = shinytheme("sandstone"),
  
   titlePanel("On-Ice Statistics for Goals Scored"),
   
   # Inputting sidebar with all statistics that can be selected
   
   sidebarLayout(
     
      sidebarPanel(
        
        #creating my drop down menu which provides all of the other statistics that can be compared to how many goals were scored
        
         selectInput("y",
                     "Statistic:",
                     choices = c("Games Played" = "gp",
                                 "Assists" = "a",
                                 "Shifts" = "shifts",
                                 "Time on Ice Percentage" = "toi_percent",
                                 "Total Shots Taken" = "i_sf",
                                 "Penalties in Minutes" = "pim")),
      
        #this function is going to allow the viewer to select a specific team and see the plotted statistics of all members of the team 
         
        radioGroupButtons("team",
                    "Select Team(s):",
                    choices = c("Anaheim Ducks" = "ANA",
                                "Arizona Coyotes" = "ARI",
                                "Boston Bruins" = "BOS",
                                "Buffalo Sabres" = "BUF",
                                "Carolina Hurricanes" = "CAR",
                                "Columbus Blue Jackets" = "CBJ",
                                "Calgary Flames" = "CGY",
                                "Chicago Blackhawks" = "CHI",
                                "Colorado Avalanche" = "COL",
                                "Dallas Stars" = "DAL",
                                "Detroit Red Wings" = "DET",
                                "Edmonton Oilers" = "EDM",
                                "Florida Panthers" = "FLA",
                                "Los Angelos Kings" = "LAK",
                                "Minnesota Wild" = "MIN",
                                "Montreal Canadiens" = "MTL",
                                "New Jersey Devils" = "NJD",
                                "Nashville Predators" = "NSH",
                                "New York Islanders" = "NYI",
                                "New York Rangers" = "NYR",
                                "Ottawa Senators" = "OTT",
                                "Philadelphia Flyers" = "PHI",
                                "Pittsburgh Penguins" = "PIT",
                                "San Jose Sharks" = "SJS",
                                "St. Louis Blues" = "STL",
                                "Tampa Bay Lightening" = "TBL",
                                "Toronto Maple Leafs" = "TOR",
                                "Vancouver Canucks" = "VAN",
                                "Vegas Golden Knights" = "VGK",
                                "Winnipeg Jets" = "WPG",
                                "Washington Capitals" = "WSH"))),

  
      
      # add in all comments/imformation that is necessary for my audience to understand my topic
      
      mainPanel(
        h3("2017-2018 NHL Season"),
        em("Select an NHL team and a statistic to see its correlation to each individual's total goals scored."),
        plotOutput("on_ice"),
        br(),
        h3("Intent:"),
        p("Focusing on how many goals were scored by individuals on each team, that result was plotted against other statistics that contribute to how succesful a team is. Some of the statistics looked at include:"),
        p("1. Games played in (out of 82 games in the season)."),
        p("2. How many assists the player had in the regular season."),
        p("3. How many shifts the player had all season."),
        p("4. The average percentage of time that a player was on the ice during a game."),
        p("5. The total shots the player took all season."),
        p("6. The total penalty minutes the player had in the season."),
        h3("Summary of Findings:"),
        p("Many conclusions can be drawn from these graphs but some of the most interesting relationships occur in the Time on Ice statistic, and the Total Shots Taken."),
        p("Time-on-Ice is a useful statistic because the clusters of players by position can help show if a team is evenly distributed in talent (where ice time is more equal across the defensemen and all four lines, or if there is a clear top line and top defense pair. Total Shots Taken is interesting because it shows whether the guys who are arguably the biggest threat offensively (able to get the most shots on net), are able to convert their opportunities into goals for their team.")
      )
    )
  )
),


#creating a tab for players that took 275 or more shots in the 2017-18 season
#this tab is useful to look at if some of the most offensively active players are actually producing majorly

tabPanel("Top Shots",
         
         fluidPage(
           
           titlePanel("Statistics of Players with the Most Shots Taken"),
           
           # Inputting sidebar with all statistics that can be selected
           
           sidebarLayout(
             
             sidebarPanel(
               
               selectInput("plot2",
                           "Statistic:",
                           choices = c("Goals" = "g",
                                       "Assists" = "a",
                                       "Shifts" = "shifts",
                                       "Time on Ice Percentage" = "toi_percent",
                                       "Penalties in Minutes" = "pim",
                                       "Games Played" = "gp"))),
               
               
               # Show a plot of the generated distribution
           
               mainPanel(
                h3("13 Players with Most Shots Taken"),
                plotOutput("players"),
                br(),
                h3("Summary of Findings:"),
                p("This graph contains only 13 players from the 2017-2018 NHL season. These were the 13 players who took a total over 275 shots throughout the year."),
                br(),
                p("By only displaying the players who shot the most -- implying that they had more opportunities than others to get a goal for their team --  it allows for conclusions to be drawn in:"),
                p("a) did they produce goals at a high level?"),
                p("b) if they did not produce at a high level, were their assists high?"),
                em("This is the number of times that their pass, or intial shot, allowed a teammate to score."),
                br(),
                p("c) did the players with the most opportunities to be on the ice (toi_percent and shifts) take advantage of it?")
         )
        )
       )
      ),

#creating third tab for demographic stats
#given the large number of athletes representing the United States and Canada, it is interesting to look at what countries top talent comes from and if there is a correlation to success in the league

tabPanel("International Representation",
         
         fluidPage(
           
           titlePanel("Country Representation and Corresponding National Stats"),
           
           # Inputting sidebar with all statistics that can be selected
           
           sidebarLayout(
             
             sidebarPanel(
               
               selectInput("plot3",
                           "Statistic:",
                           choices = c("Goals" = "g",
                                       "Assists" = "a",
                                       "Games Played" = "gp",
                                       "Penalty Mintues" = "pim"))),

             
             # create my output to be used for the demographics tab
             
             mainPanel(
               plotOutput("nationalities"),
               h3("What are you looking at?"),
               p("The most prominent feature of this graphic are the x-values of the bar plot. Each bar represents a country that has at least one representative who actively played in the 2017-2018 NHL season."),
               p("Within these bar plots is the make-up of how many players within that country play each position on the ice. Though this may not seem like a crucial variable, it is another way to determine if certain positions on the ice are better suited for dominance in offensive talent."),
               p("Finally, you are able to select statistics that lead to and are direct contributors to how much offence a player contributes. This is interesting to see the increase and decrease of each position within a nation in regards to each differnt statistic."),
               h3("Summary of Findings:"),
               p("The instinct to answering if centers and wingers are more easily inclined to scoring can be contested with the idea that defensemen get more time on the ice to set up plays or create offence."),
               p("This graphic, though skewed towards the heavily Canadian and American make-up of the NHL, can be very interesting to compare to the two previous tabs. This is because when determining elite status in the NHL, it is interesting to note if the US and Canada have a significantly greater number of elite players, as one would expect with the percentage of the league they comprise. Or is it that it does not matter how many people come from a certain part of the world, just that elite talent is spread out among them.")
               )
            
          )
        )
      )
)


# creating my server for all of the graph outputs

server <- function(input, output) {
  
   # once they select a team and a statistic, this output shows the viewer each indivdual player's correlation from this statistic to goals scored
  
  output$on_ice <- renderPlot({
    
    data %>% 
      mutate(position = case_when(position == "C" ~ "Center",
                                  position == "LW" ~ "Left Wing",
                                  position == "RW" ~ "Right Wing",
                                  position == "D" ~ "Defense",
                                  position == "LW/C" ~ "Left Wing/Center",
                                  position == "RW/C" ~ "Right Wing/Center")) %>% 
      filter(team %in% input$team) %>% 
      ggplot(aes_string(y = input$y, x = "g", color = "position")) + 
             geom_point(size = 2) +
      
    #allows me to label each individual player on the team that is selected 
    
        geom_label_repel(aes(label = h_ref_name), size = 3, force = 3) +
    
    #found this to be useful because then a relationship can be looked at as to what advantages certain positions on the ice have to success, or their other tendencies throughout games 
     
       guides(color = guide_legend("Player Position")) +
      xlab("Goals Scored") +
      ylab("Selected Statistic") +
      labs(caption = "Data from http://www.hockeyabstract.com/testimonials/nhl2017-18")
   })
  
  
  output$players <- renderPlot({
    
    data %>% 
      select(h_ref_name, team, gp, a, pts, g, i_sf, position, toi_percent, shifts, pim) %>% 
    
    # wanted to look at players who shoot most often and if that has a direct relationship to their goals scored or assists
      
      subset(i_sf > 270) %>% 
      arrange(desc(i_sf)) %>% 
      ggplot(aes_string(y = input$plot2, x = "i_sf", color = "position")) + 
             geom_point(size = 2) +
      geom_label_repel(aes(label = h_ref_name), size = 3, force = 3) +
    
    # changing the colors so that the four major positions are distinguishable in my plot
      
      scale_color_manual(values = c(C = "red", RW = "blue", LW = "dark green", D = "purple")) +
      guides(color = guide_legend("Player Position")) +
      xlab("Shots Taken") +
      ylab("Statistic") +
      labs(caption = "Data from http://www.hockeyabstract.com/testimonials/nhl2017-18")
  })
  
  output$nationalities <- renderPlot({
    
    data %>%
      mutate(position = case_when(position == "C" ~ "Center",
                                  position == "LW" ~ "Left Wing",
                                  position == "RW" ~ "Right Wing",
                                  position == "D" ~ "Defense",
                                  position == "LW/C" ~ "Left Wing",
                                  position == "RW/C" ~ "Right Wing")) %>% 
      group_by(cntry) %>% 
      ggplot(aes_string(x = "cntry", y = input$plot3, fill = "position")) +
      geom_bar(stat = "identity") +
      guides(color = guide_legend("Player Position")) +
      xlab("Country") +
      ylab("Statistic") +
      labs(caption = "Data from http://www.hockeyabstract.com/testimonials/nhl2017-18")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

