/*jshint node:true*/

require('coffee-script');

module.exports = {
    port: 8000,
    use: [
        '/', require('../src/Resource').middleware()
    ]
}
