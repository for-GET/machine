prefix = './lib'
prefix = './src'  if /\.coffee$/.test module.filename

module.exports =
  FSM: require "#{prefix}/FSM"
  FSMResource: require "#{prefix}/FSMResource"
  Resource: require "#{prefix}/Resource"
