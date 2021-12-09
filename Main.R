library(dplyr)
library(DBI)
library(RMySQL)


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
dbListFields(db, 'sales')

#Saco todos los datos de la tabla para almacenarlos en un archivo CSV por si es necesario mas adelante
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
                    order by global desc;")


str(Datos)

#Se convierten a factor las columnas de platform, genre y plusher. A enetero year
Datos <- mutate(Datos, platform= as.factor(platform), 
                        genre= as.factor(genre), 
                        publisher= as.factor(publisher), 
                        year= as.integer(year)
                )


summary(Datos)

#--------------------------------------------------------------------------------------------------

#asigno la ruta para el archivo procesado
setwd("D:/Documentos/DataAnalysis/R/Programacion-R-Santander-2021-main/Entrega")

#Genero el archvivo procesado
write.csv(Datos, "gameSales.csv", row.names = TRUE)
