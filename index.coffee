prefix = './lib'
prefix = './src'  if /\.coffee$/.test module.filename

module.exports =
  FSM: require "#{prefix}/FSM"
  middleware: require "#{prefix}/middleware"
  Resource: require "#{prefix}/Resource"
  Server: require "#{prefix}/Server"
