#!/usr/bin/env node
/*jshint node:true, strict:false*/

var Server = require('../src/Server'),
    config = require(process.argv[2]),
    app = new Server(),
    s;

config.use.forEach(function(args) {
    app.use.apply(app, args);
});
s = app.listen(config.port);

console.log('Listening on ' + JSON.stringify(s.address()))
