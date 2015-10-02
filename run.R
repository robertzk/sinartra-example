# Set up an httpuv server.

if (!require("httpuv")) install.packages("httpuv")

# Download mutatr and sinartra

if (!require("devtools")) {
  install.packages("devtools")
}

devtools::install_github("hadley/mutatr")
devtools::install_github("hadley/sinartra")
library(sinartra)

# Run the server.

port <- 8101

first_route <- function(query) {
  query$blah <- "yay"
  query
}

second_route <- function(query) {
  list("Second" = "Woohoo")
}

third_route <- function(query) {
  stop("ERROR")
}

fourth_route <- function(query) {
  list(data = iris, query = query)
}

Router$base_url("^//")
Router$get("/first/route", "first_route")
Router$get("/second/route", "second_route")
Router$get("/third/route", "third_route")
Router$get("space", function(...) { NULL })
Router$get("/fourth/route", "fourth_route")

httpuv_callbacks <- list(
  onHeaders = function(req) { NULL },
  call      = function(req) {
    list(
      status = 401L,
      headers = list(
        'Content-Type' = 'text/plain'
      ),
      body = paste('Access denied.')
    )
  },
  onWSOpen  = function(ws)  { NULL }
)

server_id <- httpuv::startServer("0.0.0.0", port, httpuv_callbacks)
on.exit({ httpuv::stopServer(server_id) }, add = TRUE)

repeat {
  httpuv::service(1)
  Sys.sleep(0.001)
}


