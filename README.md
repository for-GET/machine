# hyperrest-server

[HyperREST](http://hyperrest.com) Server is a NodeJS implementation
of the [HTTP decision diagram v4](https://github.com/andreineculau/http-decision-diagram/tree/master/v4).

In short, [I'm eating my own dog food](http://en.wikipedia.org/wiki/Eating_your_own_dog_food).


## Status

This software is highly volatile; the v4 diagram has the same status.


## Usage

```coffee
Server = require './src/Server'
Resource = require './src/Resource'

class MyResource extends Resource
  content_types_provided: () ->
    {
      'text/html': () -> '123'
    }

app = new Server()
app.use '/', MyResource.middleware()
app.listen 8000
```

#### Shell

```bash
# Shortcut to start a server from a configuration file
server ./bin/server.config.sample.js
```


## License

MIT
