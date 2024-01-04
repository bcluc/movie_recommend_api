if(!require("plumber")) install.packages("plumber")
if(!require("jsonlite")) install.packages("jsonlite")
library(plumber)
library(jsonlite)

pr <- plumber("plumber.R")

swaggerFile <- pr$swaggerFile()
swaggerFile$info$title <- "Recommendation System for Film"
swaggerFile$info$description <- "Return top 5 movie that revelant to input movie"
swaggerFile$info$version <- "12.9.03"
swagger <- toJSON(swaggerFile, pretty = TRUE, auto_unbox = TRUE)
cat(swagger, file = "plumber-swagger.json", append = FALSE)

pr$run(port = 5555)
#http://127.0.0.1:5555
