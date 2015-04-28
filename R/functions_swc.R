#functions for SWC workshop 

#conversts F degrees to C
degreeC = function(fahr){
  (fahr - 32) * (5/9)
} 

degreeF = function(cels){
  (cels)/(5/9) + 32
}




#plot gpdPercap vs. lideRxp for one year
plot_year = 
  function(the_year, data = gapminder){
    library(ggplot2)
    library(dplyr)
    data %>%
      filter(year == the_year)%>%
      ggplot(aes(y = lifeExp, x = gdpPercap, color = continent)) +
      geom_point()+
      scale_x_log10()
      }

plot.country_year = function(states, data){
  library(ggplot2)
  library(dplyr)
  data%>%
    filter(country %in% states)%>%
    ggplot(aes(y = gdpPercap, x = year, color = as.factor(year))) + 
    geom_point()+
    scale_x_log10() + 
    facet_grid( country ~ . )
}


