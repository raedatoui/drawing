Spine = require('spine')

module.exports = class BaseController extends Spine.Controller

  model: null
  template: null
  events: {}

  constructor: ->
    super

  prepareWithModel: (model) ->
    @model = model
    @render()

  render: ->
     @html @view @template, @model if @template?
