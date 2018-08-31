# before run it, set working dir to the dir contains this file

# auto install required packages
packages <- c('ggplot2','dplyr','tidyverse','fiftystater')
if (length(setdiff(packages,rownames(installed.packages())))>0)
  install.packages(setdiff(packages, rownames(installed.packages())))

# include packages
library(ggplot2)
library(dplyr)
library(tidyverse)
library(fiftystater)

# input death-form-police data
dfp15 <- read.csv("./thecounted-data/the-counted-2015.csv", stringsAsFactors = F) 
dfp16 <- read.csv("./thecounted-data/the-counted-2016.csv", stringsAsFactors = F) 

# input population data
population <- read.csv('./population.csv', stringsAsFactors = F)
colnames(population)[2:3] <- c('region','Population')
for (i in 1:nrow(population))
  population[i,2] = str_to_lower(population[i,2])

# input US data
us <- map_data("state")
# build map from stateName to stateAbbv
stateDfp <- data.frame(region = str_to_lower(state.name), state_abbv = state.abb,D15=0,D16=0)

# statistical death-from-police
for (i in 1:nrow(stateDfp))
  stateDfp[i,3] = nrow(subset(dfp15,state==stateDfp[i,2])) 
for (i in 1:nrow(stateDfp))
  stateDfp[i,4] = nrow(subset(dfp16,state==stateDfp[i,2]))

# merge data using left_join (avoid polygon chaos)
stateDf <- left_join(stateDfp,population,by='region')
df <- left_join(us,stateDf,by='region')

# draw deaths from police in 2016
p1 <- df %>%
  ggplot(aes(long, lat, group = group, fill = D16)) +
  geom_polygon(color = 'grey90',size=0.2) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(title='Deaths from police (2016)') + 
  scale_fill_continuous(
    low = "#FFBEBE", high = "red", name = "Death", label = scales::comma
  ) 
p1
# draw deaths from police divided by population, which somewhat reflect the dange level 
p2 <- df %>%
  ggplot(aes(long, lat, group = group, fill = D16/Population*1000000)) +
  geom_polygon(color = 'grey90',size=0.2) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(title='Danger level (Evaluated by average deaths from police)') + 
  scale_fill_continuous(
    low = "#FFBEBE", high = "red", name = "Level", label = scales::comma
  ) 
p2

#####################################################################
# Multiple plot function (Copy from http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/)
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
#####################################################################
# draw two plot in one page
multiplot(p1, p2, cols = 1)

