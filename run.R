# Set up an httpuv server.

if (!require("httpuv")) install.packages("httpuv")

# Download mutatr and sinartra

if (!require("devtools")) {
  install.packages("devtools")
}

devtools::install_github("hadley/mutatr")
devtools::install_github("hadley/sinartra")

# Run the server.

port <- 8101

library(


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


