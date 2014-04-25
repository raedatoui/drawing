Spine = require('spine')
BaseController = require('controllers/base')
Command = require('models/command')

module.exports = class CommandLine extends BaseController

  template: 'command'
  className: 'command-line'
  command: ''
  commands: ['C', 'L', 'R', 'B', 'Q']
  canvasWidth: 0
  canvasHeight: 0
  canvasCreated: false

  elements:
    'input' : 'commandInput'
    '.error' : 'errorMessage'

  events:
    'keyup input'      : 'onKeyup'
    'click button'     : 'loadProgram'

  sample: ["C 20 15", "L 5 2 20 2", "L 17 6 17 15", "R 2 5 13 12", "B 10 3 #F44"]
  challenge: ["C 20 4", "L 1 2 6 2", "L 6 3 6 4", "R 16 1 20 3", "B 10 3 #77a6d2"]
  program

  constructor: ->
    super
    Spine.bind 'error', (m) =>
      @showError m

  loadProgram: (e) ->
    if $(e.target).hasClass 'challenge'
      @program = @challenge.slice(0)
    else
      @program = @sample.slice(0)

    @program.reverse()
    setInterval @consumeProgram, 1000

  consumeProgram: =>
    if @program.length
      cmd = @program.pop()
      @commandInput.val(cmd)
      v = @validInput(cmd)
      @processCommand v
    else
      clearInterval @consumeProgram

  onKeyup: (e) ->
    if e.keyCode == 13
      @submit()

  submit: ->
    v = @validInput(@commandInput.val().toUpperCase())
    @processCommand v

  processCommand: (v) ->
    if not v
      @showError("you have entered an invalid command")
    else
      c = v[0]

      for i in [1..v.length-1]
        if c == 'B' and i == 3
          console.log v[i]
        else
          v[i] = parseInt(v[i])

      switch c
        when 'C'
          # clear and restart
          @clear(v)
          @sendCommand c, {w: v[1], h: v[2]}

        when 'L', 'R'
          if not @canvasCreated
            @showError("create a canvas first")
          else if @validXcoord(v[1]) and @validXcoord(v[3]) and @validYcoord(v[2]) and @validYcoord(v[4])
            @sendCommand c, {x1: v[1], y1: v[2], x2: v[3], y2: v[4]}
          else
            @showError("one of your arguments exceeds the canvas dimensions")

        when 'B'
          if not @canvasCreated
            @showError("create a canvas first")
          else if @validXcoord(v[1]) and @validYcoord(v[2])
            @sendCommand c, {x: v[1], y: v[2], c: v[3]}
          else
            @showError("one of your arguments exceeds the canvas dimensions")

        when 'Q'
          @sendCommand c

  validInput: (v) ->
    tokens = v.split(' ')
    c = tokens[0].toUpperCase()
    return false if @commands.indexOf(c) == -1
    switch c
      when 'Q'
        return tokens
      when 'C'
        return false if tokens.length != 3
        return false if not @isNumber(tokens[1]) or not @isNumber(tokens[2])
        return tokens
      when 'L', 'R'
        return false if tokens.length != 5
        return false if not @isNumber(tokens[1]) or not @isNumber(tokens[2]) or not @isNumber(tokens[3]) or not @isNumber(tokens[4])
        return tokens
      when 'B'
        return false if tokens.length != 4
        return false if not @isNumber(tokens[1]) or not @isNumber(tokens[2]) or not @isColor(tokens[3])
        return tokens

  isNumber: (i) ->
    i = parseInt(i)
    not isNaN(i)

  isColor: (c) ->
    /(^#[0-9A-F]{6}$)|(^#[0-9A-F]{3}$)/i.test c

  validXcoord: (x) ->
    x > 0 and x <= @canvasWidth

  validYcoord: (y) ->
    y > 0 and y <= @canvasHeight

  showError: (m)->
    @errorMessage.text m
    @errorMessage.fadeIn().delay(1000).fadeOut()

  clear: (v) ->
    @canvasCreated = true
    @canvasWidth = v[1]
    @canvasHeight = v[2]


  sendCommand: (name, args=null) ->
    command = new Command
    command.name = name
    command.args = args
    command.save()
    Spine.trigger 'command', command
    # @commandInput.val ''
