#
#HTML Template with bitcoin
#

@include "src/awkserver.awk"

function home()
{
    sendFile("samples/bitcoin/static/index.html")
}


BEGIN {
    info("adding routes for sample app")
    addRoute("GET", "/", "home")
    setStaticDirectory("samples/bitcoin/static")
    startAwkServer("81")
}
