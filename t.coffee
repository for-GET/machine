#!/usr/bin/env coffee

# Shell1: ./t.coffee
# Shell2: curl http://0.0.0.0:8000
# Magic

Server = require './src/Server'
Resource = require './src/Resource'

class MyResource extends Resource
  content_types_provided: () ->
    {
      'text/html': () -> '123'
    }

app = new Server()
app.use '/', MyResource.middleware()
s = app.listen 8000

address = JSON.stringify s.address()
console.log "Listening #{address}"
