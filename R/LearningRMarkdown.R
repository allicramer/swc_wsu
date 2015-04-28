#Data-Carpentry - Learning R Markdown 

#loading the gapminder data 

gapminder = read.csv("data/gapminder.csv")

#load my functions 
source("R/functions_swc.R")


plot_year(1967)

plot_by_country("China", data = gapminder)

plot_by_country("Norway", data = gapminder)
