Spine = require('spine')
BaseController = require('controllers/base')
Cell = require('controllers/cell')
Command = require('models/command')

module.exports = class Renderer extends BaseController

  template: 'renderer'
  className: 'renderer'

  elements:
    'table' : 'canvas'
    '.message' : 'message'

  events:
    'transitionend' : 'onTransitionEnd'

  cells: null
  canvasWidth: 0
  canvasHeight: 0
  duration: 50

  constructor: ->
    super
    Spine.bind "command", @consume

  consume: (command,animate=true) =>
    switch command.name
      when 'C'
        @canvas.empty()
        @createGrid(command)

      when 'L'
        @drawLine command

      when 'R'
        @drawRectangle command

      when 'B'
        @floodFill command.args.x,command.args.y, command.args.c,animate

      when 'Q'
        @quitGame()

  createGrid: (command) ->
    @message.hide()
    @el.removeClass 'quit'
    @canvasWidth = command.args.w
    @canvasHeight = command.args.h
    @cells = []
    i = 0

    while i < command.args.h
      @canvas.append "<tr id='tr-#{i}'></tr>"
      @cells.push []
      j = 0
      while j < command.args.w
        debugger
        cell = new Cell
        @appendChildTo cell, $("#tr-#{i}"), {x:j, y:i}
        @cells[i].push cell
        j++

      i++

  drawLine: (command) ->
    x1 = command.args.x1-1
    y1 = command.args.y1-1
    x2 = command.args.x2-1
    y2 = command.args.y2-1
    dir =  y1 == y2
    if dir
      row = @cells[y1]
      for i in [x1..x2]
        row[i].check()
    else if x1 == x2
      for i in [y1..y2]
        row = @cells[i]
        row[x1].check()
    else
      Spine.trigger 'error', 'no diagonal line yet in this tool'

  drawRectangle: (command) ->
    top = new Command
      name: 'L'
      args:
        x1: command.args.x1
        y1: command.args.y1
        x2: command.args.x2
        y2: command.args.y1
    top.save()
    @drawLine top

    left = new Command
      name: 'L'
      args:
        x1: command.args.x1
        y1: command.args.y1+1
        x2: command.args.x1
        y2: command.args.y2
    left.save()
    @drawLine left

    right = new Command
      name: 'L'
      args:
        x1: command.args.x2
        y1: command.args.y1+1
        x2: command.args.x2
        y2: command.args.y2
    right.save()
    @drawLine right

    bottom = new Command
      name: 'L'
      args:
        x1: command.args.x1+1
        y1: command.args.y2
        x2: command.args.x2-1
        y2: command.args.y2
    bottom.save()
    @drawLine bottom

  # x,y coord transformed to look up cells in rows
  floodFill: (x,y,color,animate) ->
    if x <= @canvasWidth and x > 0 and y<= @canvasHeight and y > 0
      cell = @cells[y-1][x-1]

      if cell.state == ''
        cell.colorize color
      else
        return

      if animate
        #animating the algorithm
        setTimeout =>
          @floodFill(x,y-1,color,animate)
          setTimeout =>
            @floodFill(x,y+1,color,animate)
            setTimeout =>
              @floodFill(x+1,y,color,animate)
              setTimeout =>
                @floodFill(x-1,y,color,animate)
              ,@duration
            , @duration
          , @duration
        , @duration

      else #testing purposes
        @floodFill(x,y-1,color,animate)
        @floodFill(x,y+1,color,animate)
        @floodFill(x+1,y,color,animate)
        @floodFill(x-1,y,color,animate)

  quitGame: ->
    @el.addClass 'quit'

  onTransitionEnd: ->
    @message.show()
