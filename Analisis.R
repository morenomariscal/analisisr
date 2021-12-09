library(dplyr)
library(DBI)
library(RMySQL)

library(ggplot2)
library(plotly)


#Realizo conexión a base de datos para obtener los datos para obtener los datos
db <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "games",
  host = "192.168.15.12",
  username = "root",
  password = "srvc.eie.1"
)

#Exploro la base de datos para validar conexión
dbListTables(db)

Datos <- dbGetQuery(db, 
                    "select name, 
                            platform, 
                            year, 
                            genre, 
                            publisher, 
                            na, 
                            eu, 
                            jp, 
                            other, 
                            global 
                    from sales 
                    where year <> 'N/A' and global>9.99
                    order by global desc;")


#Se convierten a factor las columnas de platform, genre y plusher. A enetero year
Datos <- mutate(Datos, platform= as.factor(platform), 
                genre= as.factor(genre), 
                publisher= as.factor(publisher), 
                year= as.integer(year)
)

str(Datos)

#Distribución de las ventas en los años por genero y plataforma
 gr1 <- ggplot(Datos, aes(x=global, y = genre, colour = platform )) + 
  geom_point() +   
  theme_gray() +
  facet_wrap("year")+
  xlab('Ventas mayores a 10 millones de dolares') +
  ylab('Genero')

 ggplotly(gr1)
 
 

 Datos2 <- dbGetQuery(db, 
                     "select 
                            genre, 
                            platform,
                            sum(global) as global 
                    from sales 
                    where year <> 'N/A'
                    group by genre,platform
                    order by genre")

#where year <> 'N/A' and global>9.99 and genre in ('Sports','Shooter','Racing','Action')
str(Datos2)

gr2 <- ggplot(Datos2, aes(x=platform, y = global, colour = genre )) + 
  geom_point() +   
  theme_gray() +
  xlab('Plataformas') +
  ylab('Ventas globales en millores de dolares')

ggplotly(gr2)