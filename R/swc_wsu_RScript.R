#First script for Data Carpentry Workshop

2+2
x = 8
y = x/2
y
x = 15
x
y
ls()   #lists objects in environment 

#"=" vs. " <- ": its better to use " <- " because this assigns things to the environment ALWAYS. if you use "=" within a function [mean(x=1:10)] it won't know what the object is. If you use " <- " it will [mean(x <- 1:10)]

weights  <-  c(50,60,65,82)  #used "alt + -" to get "<-" quickly 
weights 

animals  <-  c("mouse", "rat", "dog")
animals

# use "?" to get the help on a specific function 
?mean 

#gets the number of objects in a vector 
length(weights)
length(animals)

#to get the kind of object (class)
class(weights)
class(animals)

#str() lets you know the structure of an object 
str(weights)
str(animals)


#ammend a vector to add objects 
weights = c(weights, 90)    #adds to end 
weights 
weights = c(30, weights)    #adds to begining
weights 

#exersize: combine objects, x, y, and weights into a vector called "z"
z  <- c(x, y, weights)
z

#exersize: find the mean of z 
mean(z)


#========================================
#directories  

getwd()        #shows you your directory 

list.files()   #lists all the files that are in your directory

setwd("/Desktop") #changes directory to the desktop 


#loading the data
gapminder = read.csv("gapminder.csv")
gapminder

head(gapminder)     #lets you see the first few rows of data - default is 6 rows

head(gapminder, 3)  #you can chane the number it shows with "(_,#)

class(gapminder)

str(gapminder)

#exersize: using the str() command, can you determine the class of the object, how many rows, how many columns, and how many countries are represented? 

str(gapminder)

#==============================

#subsetting 
weights[1]     #gets the 1st object in weights
weights[1:3]   #gets the 1st three objects in weights 

gapminder[1,1]      #gets the 1st row, and 1st column [row,column]
gapminder[1,3]      #gets 1st row and 3rd column 
gapminder[500, 5:6] #gets the 500th row, and the 5th AND 6th column 

gapminder$pop   #gets the vector (aka the column)
gapminder[, 5]  #same as above - just doesn't use the name


#conditional subsetting 

#return all rows which have Finland in the row
gapminder[gapminder$country == "Finland", ]   

#countries and years where pop <= 100000
gapminder[gapminder$pop <= 100000, c("country", "year")] #This one is better. :) 
gapminder[gapminder$pop <= 100000, c(1,3)]


#exersize: which is not equivilent? 

#same
gapminder[50, 4]
gapminder[50, "lifeExp"]

#not SAME (also doesn't work as there are not 50 columns)
gapminder[50, 4]
gapminder[4,50]

#same
gapminder[50, 4]
gapminder$lifeExp[50]


#exercise: which countries in the data have life expectancies greater than 80? 
gapminder$country[gapminder$lifeExp > 80]
gapminder[gapminder$lifeExp > 80, "country"]

#country with the lowest life expectancy 
gapminder[gapminder$lifeExp == min(gapminder$lifeExp), "country"]



#===============================
#DPLYR package!!!! 
#works faster because it is mostly coded in C++ 
#allows you to connect to an external database - YAY!!!!

#install a package with a command 
install.packages("dplyr")

library("dplyr")

#subsetting in dplyr 

#keeps columns 
select(gapminder, country, year, pop)

#keeps rows 
filter(gapminder, country == "Finland")


#keep certain columns and certain rows - rather than nesting functions or just making intermediate dataframes 
#instead, we make a "pipe" - %>% : takes whats to the left of it and puts it to the right of it 

gapminder_small = gapminder %>%    #use the gapminder dataset
  filter(pop <= 100000) %>%        #keep the rows where population <= 100000
  select(country, year)            #give me the country and year columns


#exercise:  use pipes to subset the gapminder data to include rows where the gdpPercap was >= 35,000. Retain columns country years and gdpPercap

gapminder %>% 
  filter(gdpPercap >= 35000) %>%
  select(country, year, gdpPercap)


#--------------------------------

#Adding new columns in dplyr
#the mutate() function

gapminder %>%                               #use gapminder dataset
  mutate(totalgdp = gdpPercap * pop) %>%    #add a column that is gdpPercap * pop 
  head                                      #put it into a header 


#splitting into groups keeping continent and adding new column
gapminder %>%                               #use gapminder dataset
  mutate(totalgdp = gdpPercap * pop) %>%    #add a column that is gdpPercap * pop 
  group_by(continent) %>%                   #groups the data 
  summarize(meangdp = mean(totalgdp))       #summarizes the mean, but you need to make a new column
  
#splitting into groups keeping continent and year and adding a new column 
gapminder %>%                               #use gapminder dataset
  mutate(totalgdp = gdpPercap * pop) %>%    #add a column that is gdpPercap * pop 
  group_by(continent, year) %>%                   #groups the data 
  summarize(meangdp = mean(totalgdp))       #summarizes the mean, but you need to make a new column


meanmingdp  <-  gapminder %>% 
  mutate(totalgdp = gdpPercap * pop) %>%
  group_by(continent, year) %>%
  summarize(meangdp = mean(totalgdp),
           mingdp = min(totalgdp))

#exercise: use group_by and summarize to find the maximum life expectancy for each contient
gapminder %>%
  group_by(continent) %>%
  summarize(maxLife = max(lifeExp))

#exercise: use group_by() and summarize(0 to find the mean, min, and max life expectancy for each year 
gapminder %>% 
  group_by(year) %>%
  summarize ( meanLife = mean(lifeExp), 
              minLife = min(lifeExp), 
              maxLife = max(lifeExp))


#exercise: pick a country and find the population for each year in the data prior to 1982. Return a dataframe with the columns country, year, and pop 
NorwayDat  <-  gapminder %>%
  select(country, year, pop)%>%
  filter(country == "Norway", year < 1982)
  
NorwayDat

#---------------------------------------------------------
#-- many functions have a "summarize()"                 --
#-- if you encounter a duplicate function situation     --
#-- use :: to make it use the right one:                --
   dplyr::summarize(mean = mean(lifeExp))               --
#---------------------------------------------------------


#exporting the data - aka creating a dataframe and then saving it somewhere besides R

write.csv(gapminder_small, "gapminder_sml.csv")      #1st is the data, then the loaction (we have a directory so we don't need to define one), then the file name


#==========================================================
#FUN WITH GGPLOT!!!! 

#lets clear the workspace: 
rm(list = ls())              #the rm() function is what does this. If we said rm(x) it would delete x, for example

#pkge
library(ggplot2)


#bringing in the data 
gapminder = read.csv("gapminder.csv")

#scatterplot of lifeExp vs. gdpPercap 
ggplot(gapminder, aes(x=gdpPercap, y = lifeExp)) + 
  geom_point()

p = ggplot(gapminder, aes(x = gdpPercap, y = lifeExp))

p2 = p + geom_point()

#changing to the log scale 
#the syntax is "scale_[aesthetic]_[scale]"
p3 <- p + geom_point() + scale_x_log10() 


#exercise: make a scatterplot of lifeExp vs gdpPercap with only data from Chin a

ggplot(gapminder %>%
         filter(country == "China"),
       aes(x =gdpPercap, y = lifeExp)) + 
  geom_point(size = 3, col = "red")

#OR .... even nicer ... 
(chinaplot<- gapminder%>%
  filter(country == "China") %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)))
 
#^ by putting parentheses around the whole thing, it will reassign the object as well as print it 

chinaplot +
  geom_point(sie = 3, col = "blue")
  scale_x_log10()


#arguments in aes()
    size   #makes size correlate to aspects of the data
    color  #makes it possible to color based on data aspects 
    alpha  #it the opacity of the data -  make it clear based on things 

#funplot - adding two things - the "or" ability 
(FinvChina<- gapminder%>%
   filter(country %in% c("China", "Finland")) %>%
   ggplot(aes(x = gdpPercap, y = lifeExp, color = country)) + 
   geom_point(size = 3))


#exercise: try out size, shape, and color aesthetics (like contientn and population)
gapminder%>%
  group_by(continent, year)%>%
  summarize(totalpop = sum(pop), meanlifespan = mean(lifeExp), meangdp = mean(gdpPercap)) %>%
  ggplot(aes(x = meangdp, y = meanlifespan, size = totalpop, color = continent)) + 
  geom_point()
  

#lines instead of dots 
chinaplot + geom_line()

#lines AND dots 
chinaplot + 
  geom_line(size = 2, col = "lightblue") +
  geom_point(size = 4, col = "violetred")


#you can imbed aes(into geom_x() functions)

chinaplot + 
  geom_line(size = 2, col = "lightblue") +
  geom_point(size = 4, aes(color = as.factor(year)))


#exercise: grab the data that has China and Inda. Lines should be in black, and poinits should be colored by the country 

gapminder%>%
  filter(country %in% c("China", "India")) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) + 
  geom_line(aes(group = country)) + 
  geom_point(aes(color = country))

#^ we learned about the "group()" aes thing here 

#you can also say: 
gapminder%>%
  filter(country %in% c("China", "India")) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, group = country)) + 
  geom_line(color = "black") + 
  geom_point(aes(color = country))


#making a histogram 
gapminder %>%
  filter(year == 2007)%>%
  ggplot(aes(x = lifeExp))+
  geom_histogram( binwidth = 3.5, fill = "lightblue", color = "black")


#making a boxplot 
gapminder %>%
  filter(year == 2007)%>%
  ggplot(aes(y =lifeExp, x = continent))+
  geom_boxplot( binwidth = 3.5, fill = "lightblue", color = "black")


#make your boxplot sizeways! 
gapminder %>%
  filter(year == 2007)%>%
  ggplot(aes(y =lifeExp, x = continent))+
  geom_boxplot( binwidth = 3.5, fill = "lightblue", color = "black") +
  coord_flip()


#by year, with boxplot, jittered
gapminder %>%
  filter(year == 2007)%>%
  ggplot(aes(y =lifeExp, x = continent))+
  geom_boxplot()+
  geom_point(position = position_jitter(width = 0.1, height =0)) 


#faceting - makes lots of side by side plots 

#horizontal 
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) + 
  geom_point() +
  scale_x_log10() + 
  facet_grid(~continent)

#vertical 
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) + 
  geom_point() +
  scale_x_log10() + 
  facet_grid(continent ~.)

#even more subsetted! 
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) + 
  geom_point() +
  scale_x_log10() + 
  facet_grid(continent ~ year)

#facetwrap 
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) + 
  geom_point() +
  scale_x_log10() + 
  facet_wrap(~continent)

#with colors
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent)) + 
  geom_point() +
  scale_x_log10() + 
  facet_wrap(~year)


#exercise: select five countries of interest, and plot lifeExp vs. gdpPercap across time (with geom_line()) faceting by country 

plot<- gapminder%>%
  filter(country %in% c("Finland", "Norway", "Denmark", "Sweden", "Netherlands" ))%>%
  ggplot(aes(x = gdpPercap, y = lifeExp, fill = country))+
  geom_line()+
  facet_wrap(~country) +
  theme_bw()

#saving a plot 

ggsave("5plot.png", plot)   #define the path with the filename, if you don't want it in the direcotory, you can also change hight and width with "hieght' and "width" after the data.  


















