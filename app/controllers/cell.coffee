Spine = require('spine')
BaseController = require('controllers/base')

module.exports = class Cell extends BaseController

  tag: 'td'
  state: ''

  constructor: ->
    super

  render: ->
    super
    @el.html '&nbsp;'

  check: ->
    @state = 'x'
    @el.html "x"
    @el.css 'color', 'black'

  colorize: (color) ->
    @state = 'o'
    @el.html "&#x25cf"
    @el.css 'color', color


