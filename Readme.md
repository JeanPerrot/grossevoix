A remote announce system - pipe announcement to a home sonos system through a restful api.
And maybe with an app.

### layout
A raspberry pi (server) accesses the sonos system through wifi, switches it to line-in, then emits sound through it's audio out.
A web server is running on the raspberry pi.
The server regularly checks the home IP address and publishes it to an agreed-upon accessible location.
The home router is setup to forward a specific outside request port to the raspberry pi

Using the system is done by
* checking the home IP address
* Posting to the rest URL


#### libraries
It uses a local, running sonos api server
https://github.com/jishi/node-sonos-http-api

A local TTS command generates a file, then exposes it to the SONOS api
[or could simply serve it directly from an endpoint...!]


#### TODO -
It would be fun to use docker to package & launch the node-sonos-http-api server (and this one)
