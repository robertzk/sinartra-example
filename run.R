# Set up an httpuv server.

if (!require("httpuv")) install.packages("httpuv")

port <- 8101

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


