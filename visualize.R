#visualize 視覺化

# install.packages("dygraphs")
library(dygraphs)
dygraph(nhtemp, main = "New Haven Temperatures") %>% 
  dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"))

# install.packages("metricsgraphics")
library(metricsgraphics)
mjs_plot(mtcars, x=wt, y=mpg) %>%
  mjs_point(color_accessor=carb, size_accessor=carb) %>%
  mjs_labs(x="Weight of Car", y="Miles per Gallon")

# install.packages("leaflet")
library(leaflet)
pal <- colorQuantile("YlOrRd", NULL, n = 8)
leaflet(orstationc) %>% 
  addTiles() %>%
  addCircleMarkers(color = ~pal(tann))

# install.packages("devtools")
library(devtools)
install_github("Rtwmap", "wush978")
#data location
load("F:/GitHub/R_Repository/packages/Rtwmap/data/village2010.rda")

random.color <- as.factor(sample(1:3, length(village2010), TRUE))
color <- rainbow(3)
village2010$random.color <- random.color
spplot(village2010, "random.color", col.regions = color, main = "Taiwan Random Color")

plot(county1984)




install.packages("RgoogleMaps")
urlEncodePath(county1984$county)
library(RgoogleMaps)
