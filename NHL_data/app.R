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


# Beginning UI

ui <- navbarPage(
  "NHL Stats in Correlation to Goals Scored",
  
  #creating a tab for all statistics that occur during a game and will be compared to Goals Scored
  tabPanel("On Ice Stats",
  
  fluidPage(theme = shinytheme("sandstone"),
  
   titlePanel("On-Ice Statistics for Goals Scored"),
   
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
      
        #this function is going to allow the viewer to select a specific team and see the plotted statistics of every members of the team for whatever statistic they select
         
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
        h2("Intent:"),
        p("This tab allows you to select any team in the NHL, and see the goals scored (x-axis) by each individual on that team plotted against six (6) other statistics that may influence play (y-axis). These statistics include:"),
        p("1. Games played in (out of 82 games in the season)."),
        p("2. How many assists the player had in the regular season."),
        p("3. How many shifts the player had all season."),
        p("4. The average percentage of time that a player was on the ice during a game."),
        p("5. The total shots the player took all season."),
        p("6. The total penalty minutes the player had in the season."),
        h2("Summary of Findings:"),
        h3("1. Goals versus Games Played: "),
        p("- Common to see players who play more games throughout the year scoring more goals, but can see outliers in men who did not play as many games as their teammates but still had a large offensive presence."),
        p("*Auston Matthews (Toronto) is a good example of someone who played nearly 20 less games but still scored over 30 goals"),
        h3("2. Goals versus Assists:"),
        strong("3 Major Possibilities:"),
        p("a) Higher Assists & Lower Goals: Players who set up their teammates often in the offensive zones or have a tendency to pass over shooting."),
        p("b) Lower Assists & Higher Goals: Players with an accurate shot or have good net-front presence and can find the puck in traffic (highly populated areas of the ice and still get goals)"),
        p("c) High Assists & High Goals: Players who are on a very offensively dominant line, where they feed off each other in equal goals and assists, or an overall strong offensive threat with passing and shooting."),
        h3("3. Goals versus Shifts/Time-on-Ice Percentage:"),
        p("- These statistics are similar but really interesting data comes in where you see teams with a clear top defensive pairing and a top line or two, and what teams have their manpower split between all four offensive lines and their defensemen all getting equal opportunity on ice."),
        p("    - In other words, some teams have a line or two (offensively) that get the majority of the minutes because they are their elite lines, while other teams spread out their talent more among all four offensive lines."),
        p("- From here you can look at the guys who get most time on ice, and if they are offensively dangerous in proportion to how many opportunities they get to play."),
        p("The Detroit Red Wings are a good example of equally distributed time-on-ice percentages. They have 7 defensemen (in yellow) over 25% in percentage of time on ice (per game). Meanwhile 10 of their forwards (on average 12 in the lineup for a game) are over 22% in the same statistic."),
        h3("4. Striking Stats:"),
        p("a) Vegas is a team where defense was pretty evenly split"),
        p("b) Buffalo is a team with a clear top defense-pair (Scandella-Ristolainen)"),
        p("c) Boston is a team with a clear top line (Marchand-Bergeron-Pastrnak)")
      )
    )
  )
),


#creating a tab for players that took 275 or more shots in the 2017-18 season
#this tab is useful to look at if some of the most offensively active players are actually producing majorly

tabPanel("Top Shots",
         
         fluidPage(
           
           titlePanel("Does Shots Taken Mean Offensive Threat?"),
           
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
                h2("13 Players with Most Shots Taken"),
                plotOutput("players"),
                br(),
                h3("Intent:"),
                p("Interested in the correlation between the amount of shots a player took compared to similar statistics as the previous page. The 13 players who took the most shots in the NHL regular season last year were selected (over 275 shots) and plotted with each other to see how their strengths matched up. Another reason I chose Shots Taken is because the number of shots a player takes is not necessarily an indicator of offensive threat, but paired with these other statistics you can see the strengths of most of these players."),
                p("By only displaying the players who shot the most -- implying that they had more opportunities than others to get a goal for their team --  it allows for conclusions to be drawn in:"),
                p("a) did they produce goals at a high level?"),
                p("b) if they did not produce at a high level, were their assists high?"),
                em("This is the number of times that their pass, or intial shot, allowed a teammate to score."),
                br(),
                p("c) did the players with the most opportunities to be on the ice (toi_percent and shifts) take advantage of it?"),
                h2("Summary of Findings:"),
                h4("1. First it it interesting to go to Goals and see if the men taking the most shots are actually scoring the most, or if they have a tendency to shoot a lot, but don’t necessarily get the results."),
                h5("In this statistic notable points are:"),
                h5("a) Alex Ovechkin (Washington) takes a lot of shots and he scores a lot of goals"),
                h5("b) Contrastingly, Brent Burns (San Jose) was third in shots taken last year, but he scored less than half of the goals Ovechkin did."),
                h5("c) Connor McDavid (Edmonton) and Taylor Hall (New Jersey) are examples of guys who do not shoot as often as Ovechkin, but they scored within 10 goals of him."),
                br(),
                h4("2. From here, you can plot Assists against Shots Taken and see why Brent Burns is so offensively dangerous."),
                h5("Though he is not scoring as dominantly as others, you can see his playmaking abilities in that his shots may not be going in, but his teammates are either getting the rebounds or he is setting up his teammates for goals."),
                br(),
                h4("3. Shifts and Time-on-Ice are interesting because you can try and gauge if a player is shooting or scoring more because he gets more time on the ice than other players."),
                h5("Another area where Alex Ovechkin shines is that coming from a team that splits ice time more evenly between all four offensive lines, he gets less shifts but is still a threat offensively whenever he is on the ice."),
                br(),
                h4("4. Finally, Penalties in minutes is on here because I wanted to see if the players who were getting the most offensive opportunities tended to stay out of penalty trouble, or if there were again outliers in being more physical but also being an offensive threat."),
                h5("Evander Kane (Buffalo) is the interesting player in this statistic because he is in the middle for most shots taken, yet he had the most penalty minutes in this elite group by a wide margin. Meaning E. Kane gets less time on ice due to penalties but is still one of the highest shot producers in the league.")
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
}

# Run the application 
shinyApp(ui = ui, server = server)

