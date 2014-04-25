Spine = require('spine')
BaseController = require('controllers/base')

module.exports = class Cell extends BaseController

  tag: 'td'
  state: ''
  template: 'cell'

  elements:
    '.mark' : 'mark'
    '.coord' : 'coord'

  constructor: ->
    super

  render: ->
    super
    @mark.html '&nbsp;'

  check: ->
    @state = 'x'
    @mark.html "x"
    @el.css 'color', 'black'

  colorize: (color) ->
    @state = 'o'
    @mark.html "&#x25cf"
    @el.css 'color', color


