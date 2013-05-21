#{_, should, nock} = require './utils'

#describe 'basic', () ->
#  it 'should', (done) ->
    expressMachine = require '../index'
    app = require('express')()

    app.all '/items/:id', expressMachine {
      app: app
      module: 'items'
      to_html: (context) ->
        'test'
    }
    app.listen 3000
