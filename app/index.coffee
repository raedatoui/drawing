require('lib/setup')

Spine = require('spine')
CommandLine = require('controllers/command_line')
Renderer = require('controllers/renderer')

class App extends Spine.Controller
  constructor: ->
    super
    @render()
    # Getting started - should be removed

  render: ->
    @html @view "main"
    @commandLine = new CommandLine()
    @appendChild @commandLine

    @renderer = new Renderer()
    @appendChild @renderer

module.exports = App
