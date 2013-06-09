prefix = './lib'
prefix = './src'  if /\.coffee$/.test module.filename

module.exports =
  Server: require "#{prefix}/Server"
  Resource: require "#{prefix}/Resource"
